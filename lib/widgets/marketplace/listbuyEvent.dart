import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import 'package:obdapp/route/autoroute.dart';
import 'package:obdapp/widgets/historywidgets/pathlist.dart';
import 'package:web3dart/web3dart.dart';

class ListEventbuy extends StatefulWidget {
  List<dynamic> userpath;
  List<dynamic> userbuy;
  Function getfund;

  ListEventbuy(
      {required this.getfund,
      required this.userpath,
      required this.userbuy,
      super.key});

  @override
  State<ListEventbuy> createState() => _ListEventbuyState();
}

class _ListEventbuyState extends State<ListEventbuy> {
  Future<void> showerror(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TapRegion(
          onTapOutside: (tap) {
            context.router.popForced();
          },
          child: AlertDialog(
            title: const Text(''),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(erro),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void troca(int i) {
    widget.userbuy.add(widget.userpath[i]);
    widget.userpath.removeAt(i);
    print(widget.userpath.length);

    print(widget.userbuy.length);
    setState(() {});
  }

  void sendvalue(String v, int index) {
    blockchain auxblock = blockchain();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            onPressed: () {
              context.router.popForced();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Box userdata = await Hive.openBox<wallet>('wallet');
              wallet user = userdata.getAt(0);
              
              if (user.blockchain) {
                if (userdata.isNotEmpty &&
                    await auxblock.checkServerStatus(user.site + "/jwtserver/")) {
                  var response = await auxblock
                      .getserver(user.site + "/jwtserver/get/sendcontract");

                  // 2. Correctly convert the address string to an EthereumAddress.
                  final contractAddress =
                      EthereumAddress.fromHex(response["adress"].toString());

                  final abiList = response["abi"];

                  // Re-encode the List<dynamic> into a JSON String:
                  final abiString = jsonEncode(abiList);

                  final contract = DeployedContract(
                      ContractAbi.fromJson(abiString, 'SendEther'),
                      contractAddress);

                  final storage = FlutterSecureStorage();
                  var aux = await storage.read(key: 'privatekey');
                  String? help = aux;
                  String rpc = user.site;

                  var apiUrl = rpc + "/testeu/"; //Replace with your API
                  var httpClient = Client();
                  var ethClient = Web3Client(apiUrl, httpClient);
                  if (help != null) {
                    var credentials = EthPrivateKey.fromHex(help);

                    var address = credentials.address;

                    final sendFunction = contract.function('sendViaCall');
                    // The standard scaling factor (10^18)
                    final BigInt weiBase = BigInt.from(10).pow(18);

                    // --- Conversion Logic ---

                    // The string you want to convert
                    String ethString = v;

                    // 1. Split the string into integer and decimal parts
                    final List<String> parts = ethString.split('.');
                    final String integerPart = parts[0]; // "0"
                    final String decimalPart =
                        parts.length > 1 ? parts[1] : ''; // "53"

                    // 2. Convert the integer part to Wei
                    // integerPart * 10^18 (e.g., 0 * 10^18)
                    final BigInt integerWei =
                        BigInt.parse(integerPart) * weiBase;

                    // 3. Convert the decimal part to Wei
                    BigInt decimalWei = BigInt.zero;
                    if (decimalPart.isNotEmpty) {
                      // Determine the power needed to scale the decimal part correctly
                      // e.g., for "53", we need 10^(18-2) = 10^16
                      final int scaleFactor = 18 - decimalPart.length;

                      if (scaleFactor >= 0) {
                        // 53 * 10^16
                        final BigInt scale = BigInt.from(10).pow(scaleFactor);
                        decimalWei = BigInt.parse(decimalPart) * scale;
                      } else {
                        // Handle cases like "0.1234567890123456789" (more than 18 decimals)
                        // You'd typically truncate or handle this as an error.
                        // For this example, we'll just ignore the extra digits.
                        final String safeDecimal = decimalPart.substring(0, 18);
                        decimalWei = BigInt.parse(safeDecimal);
                        // Note: This simple truncation is often acceptable.
                      }
                    }

                    // 4. Combine them!
                    final BigInt weiToSend = integerWei + decimalWei;

                    // You can now call rpc methods. This one will query the amount of Ether you own
                    EtherAmount balance = await ethClient.getBalance(address);

                    if (balance.getInWei >= weiToSend) {
                      final correctChainId = 1337; // Example: Sepolia
                      // Convert the string to an EthereumAddress object
                      final recipientAddress = EthereumAddress.fromHex(
                          "0xfe3b557e8fb62b89f4916b721be55ceb828dbd73");
                      var txHash = await ethClient.sendTransaction(
                        credentials,
                        Transaction.callContract(
                          contract: contract,
                          function: sendFunction,
                          parameters: [recipientAddress],
                          //FIX 2: Pass the value you want to send using the 'value' field
                          value: EtherAmount.inWei(weiToSend),
                          maxGas: 100000,
                        ),
                        chainId: correctChainId,
                      );
                      print('Transaction sent. Hash: $txHash');
                      // 2. Poll for the transaction receipt
                      print('Waiting for transaction to be mined...');

                      TransactionReceipt? receipt;
                      // Wait up to 30 seconds (or adjust for your network speed)
                      for (var i = 0; i < 30; i++) {
                        receipt = await ethClient.getTransactionReceipt(txHash);
                        if (receipt != null) {
                          break; // Receipt found, exit the loop
                        }
                        await Future.delayed(Duration(
                            seconds: 1)); // Wait 1 second before checking again
                      }

                      // 3. Check the status
                      if (receipt == null) {
                        showerror("Transação não foi feita");
                        print('Transaction not mined within timeout period.');
                      } else {
                        // The status == 1 is success, status == 0 is failure
                        if (receipt.status == true) {
                          print('Transaction SUCCESS!');
                          print('Block Number: ${receipt.blockNumber}');
                          troca(index);
                          widget.getfund();

                          await ethClient.dispose();

                          context.router.popForced();
                          // You can also look at receipt.gasUsed for gas consumption
                        } else {
                          print(
                              'ransaction FAILED (Status: 0). Check gas, contract logic, or value sent.');
                          showerror("Erro no envio da transação");
                        }
                      }
                    } else {
                      showerror("Você não tem o valor necessario");
                    }
                  }
                  //  print(response);
                }
              }
            },
            child: Text('Enviar'),
          ),
        ],
        title: Text('Comprar Trajeto'),
        content: SizedBox(
          width: 300,
          height: 70,
          child: Column(
            children: [
              Text("Valor a ser enviado", style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 10),
              Text(v, style: TextStyle(fontSize: 15.0))
            ],
          ),
        ),
      ),
    );
  }

  void buy(List<dynamic> buy, List<dynamic> own) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 400,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userpath.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTap: () {
                    sendvalue(widget.userpath[index].value, index);
                    setState(() {});

                    //context.router.push(EventListPath(
                    //    event: widget.userpath[index], index: index));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height:
                              120 * MediaQuery.textScalerOf(context).scale(1),
                          width:
                              500 * MediaQuery.textScalerOf(context).scale(1),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 190, 190, 190), // Set the border color
                              width: 1.0, // Set the border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: Pathlist(
                              add: widget.userpath[index].add,
                              completude: double.parse(
                                      widget.userpath[index].fuel_E) /
                                  double.parse(widget.userpath[index].fuel_B),
                              value: widget.userpath[index].value,
                              number: widget.userpath[index].id.toString(),
                              abastecimento: widget
                                  .userpath[index].abastecimento
                                  .toString(),
                              date: widget.userpath[index].date.toString(),
                              Paths: widget.userpath[index].paths,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
