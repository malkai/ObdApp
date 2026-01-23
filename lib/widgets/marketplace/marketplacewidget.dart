import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import 'package:obdapp/widgets/historywidgets/listCloseEvent.dart';
import 'package:obdapp/widgets/marketplace/listbuyEvent.dart';
import 'package:web3dart/web3dart.dart';

class MarketPlaceWidget extends StatefulWidget {
  const MarketPlaceWidget({super.key});

  @override
  State<MarketPlaceWidget> createState() => _MarketPlaceWidgetState();
}

class _MarketPlaceWidgetState extends State<MarketPlaceWidget> {
  double amount = 1.0;
  var value = TextEditingController(text: '');
  var add = TextEditingController(text: '');

  bool show = true;

  List<dynamic> buypath = [];
  List<dynamic> ownpath = [];
  List<dynamic> users = [];

  Future<void> getpath() async {
    Box userdata = await Hive.openBox<wallet>('wallet');
    wallet user = userdata.getAt(0);
    Box selling = await Hive.openBox<wallet>('sellingwallet');
    blockchain auxblock = blockchain();

    if (userdata.isNotEmpty) {
      blockchain auxblock = blockchain();
      if (user.blockchain) {
        //print(await auxblock.checkconnection(www.google.com));

        if (await auxblock.checkServerStatus(user.site + "/jwtserver/")) {
          var response =
              await auxblock.getserver(user.site + "/jwtserver/get/users");

          print("Resposta");
          print(response);
          if (response.length > 1) {
            if (response != "Não existem usuarios") {
              int? listLength = response?.length;
              if (listLength != null) {
                for (int i = 0; i < listLength; i++) {
                  wallet useraux = wallet(add: response[i], name: "");
                  if (selling.isEmpty) {
                    selling.add(useraux);
                  } else {
                    final matches = selling.values
                        .where((item) => item.add == useraux.add)
                        .toList();

                    if (matches.isEmpty) {
                      if (user.add != useraux.add.toLowerCase()) {
                        selling.add(useraux);
                      }
                    } else {
                      print("elemento existe");
                    }
                  }
                  //auxblock.getpaths(response[i]);
                }
                users = selling.values.toList();
                var listadd = selling.values.toList();
                for (int i = 0; i < listadd.length; i++) {
                  await auxblock.getpathsbuy(listadd[i].add);
                }
                buypath.clear();

                for (int i = 0; i < listadd.length; i++) {
                  Box userpathc =
                      await Hive.openBox<Event>('buypath' + listadd[i].add);
                  var listuser = userpathc.values.toList();
                  for (int i = 0; i < listuser.length; i++) {
                    if (listuser[i].paths.length > 0) buypath.add(listuser[i]);
                  }
                  //buypath.add(listuser);
                }
                setState(() {
                  buypath;
                });
              }
            }
          }
        }
      }
    }
  }

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

  void sendvalue(TextEditingController v, a) {
    blockchain auxblock = blockchain();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            onPressed: () {
              value.text = "";
              add.text = "";

              context.router.popForced();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (v.text == "" && a.text == "") {
                //0x4288201bac903f84648e81a07f793c9e7d893692
                showerror("Um dos campos está vazio");
              } else {
                Box userdata = await Hive.openBox<wallet>('wallet');
                wallet user = userdata.getAt(0);

                if (user.blockchain) {
                  if (userdata.isNotEmpty &&
                      await auxblock
                          .checkServerStatus(user.site + "/jwtserver/")) {
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
                      print("oi3");
                      var credentials = EthPrivateKey.fromHex(help);

                      var address = credentials.address;

                      final sendFunction = contract.function('sendViaCall');
                      // The standard scaling factor (10^18)
                      final BigInt weiBase = BigInt.from(10).pow(18);

                      // --- Conversion Logic ---

                      // The string you want to convert
                      String ethString = v.text;

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
                        print("oi4");
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
                          final String safeDecimal =
                              decimalPart.substring(0, 18);
                          decimalWei = BigInt.parse(safeDecimal);
                          // Note: This simple truncation is often acceptable.
                        }

                        // 4. Combine them!
                        final BigInt weiToSend = integerWei + decimalWei;

                        // You can now call rpc methods. This one will query the amount of Ether you own
                        EtherAmount balance =
                            await ethClient.getBalance(address);

                        final basicFormatRegex =
                            RegExp(r"^(0x)?[0-9a-fA-F]{40}$");

                        String helpadd = add.text;
                        bool isBasicFormatValid =
                            basicFormatRegex.hasMatch(helpadd);
                        if (isBasicFormatValid) {
                          if (balance.getInWei >= weiToSend) {
                            final correctChainId = 1337; // Example: Sepolia
                            // Convert the string to an EthereumAddress object
                            final recipientAddress =
                                EthereumAddress.fromHex(helpadd);
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
                              receipt =
                                  await ethClient.getTransactionReceipt(txHash);
                              if (receipt != null) {
                                break; // Receipt found, exit the loop
                              }
                              await Future.delayed(Duration(
                                  seconds:
                                      1)); // Wait 1 second before checking again
                            }

                            // 3. Check the status
                            if (receipt == null) {
                              print(
                                  'Transaction not mined within timeout period.');
                            } else {
                              // The status == 1 is success, status == 0 is failure
                              if (receipt.status == true) {
                                print('Transaction SUCCESS!');
                                print('Block Number: ${receipt.blockNumber}');
                                context.router.popForced();
                                // You can also look at receipt.gasUsed for gas consumption
                              } else {
                                showerror("Transação invalida");
                              }
                            }
                          } else {
                            showerror("Você não tem o valor necessario");
                          }
                        } else {
                          showerror("Endereço invalido");
                        }

                        await ethClient.dispose();
                        getfund();
                      } else {
                        print("oierro");
                        showerror("Valor tem que estar em float 0.0");
                      }
                    }
                    //  print(response);
                  }
                }
              }
            },
            child: Text('Enviar'),
          ),
        ],
        title: Text('Enviar Criptocredito'),
        content: SizedBox(
          width: 300,
          height: 280,
          child: Column(
            children: [
              TextField(
                controller: a,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Wallet Adress',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: v,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getether() async {
    Box userdata = await Hive.openBox<wallet>('wallet');
    blockchain auxblock = blockchain();
    if (userdata.isNotEmpty) {
      wallet user = userdata.getAt(0);
      blockchain auxblock = blockchain();

      final storage = FlutterSecureStorage();
      var aux = await storage.read(key: 'privatekey');
      print(aux);

      //print(await auxblock.getserver(user.site+"/jwtserver"));
      if (await auxblock.checkServerStatus(user.site + "/jwtserver/") &&
          aux != null) {
        String? help = aux;
        String rpc = user.site;

        var apiUrl = rpc + "/testeu/"; //Replace with your API
        var httpClient = Client();
        var ethClient = Web3Client(apiUrl, httpClient);
        print(await ethClient.getGasPrice());
        var credentials = EthPrivateKey.fromHex(help);
        print(credentials);
        var address = credentials.address;
        print(address);

        Map<String, dynamic> data = {
          'wallet': user.add,
        };
        auxblock.postEvent(user.site + "/jwtserver/receive", data);
        Future.delayed(const Duration(seconds: 5)).then((value) => {getfund()});
      }
    }
  }

  void getfund() async {
    Box userdata = await Hive.openBox<wallet>('wallet');
    if (userdata.isNotEmpty) {
      wallet user = userdata.getAt(0);
      blockchain auxblock = blockchain();

      final storage = FlutterSecureStorage();
      var aux = await storage.read(key: 'privatekey');

      //print(await auxblock.getserver(user.site+"/jwtserver"));
      if (await auxblock.checkServerStatus(user.site + "/jwtserver/") &&
          aux != null) {
        String blockchain = user.site;

        var apiUrl = blockchain + "/testeu/"; //Replace with your API
        var httpClient = Client();
        var ethClient = Web3Client(apiUrl, httpClient);
        String? help = aux;

        print(await ethClient.getGasPrice());
        var credentials = EthPrivateKey.fromHex(help);
        print(credentials);
        var address = credentials.address;
        print(address);
        // You can now call rpc methods. This one will query the amount of Ether you own
        EtherAmount balance = await ethClient.getBalance(address);
        print(balance);
        amount = balance.getValueInUnit(EtherUnit.ether);
        setState(() {
          amount;
        });
      }
    }
  }

  @override
  void initState() {
    getfund();
    getpath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("Carteira", style: TextStyle(fontSize: 25.0)),
          ),
          SizedBox(
            height: 10 * MediaQuery.textScalerOf(context).scale(1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () {
                  setState(() {
                    //getpath();
                    getether();
                  });
                },
                child: Text(
                  'Depositar',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () {
                  sendvalue(value, add);
                  setState(() {});
                },
                child: Text(
                  'Enviar',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () async {
                  getfund();
                  setState(() {});
                },
                icon: const Icon(Icons.currency_exchange,
                    color: Color(0xFFFFFFFF), size: 25), // The icon to display
              ),
            ],
          ),
          SizedBox(
            height: 10 * MediaQuery.textScalerOf(context).scale(1),
          ),
          Container(
            height: 50 * MediaQuery.textScalerOf(context).scale(1),
            width: 310 * MediaQuery.textScalerOf(context).scale(1),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color.fromARGB(
                    255, 190, 190, 190), // Set the border color
                width: 1.0, // Set the border width
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount.toString() + " MLK",
                    style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
          SizedBox(
            height: 10 * MediaQuery.textScalerOf(context).scale(1),
          ),
          Container(
            child: Text("Compras de Eventos", style: TextStyle(fontSize: 25.0)),
          ),
          SizedBox(
            height: 10 * MediaQuery.textScalerOf(context).scale(1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () {
                  setState(() {
                    show = true;
                  });
                },
                child: Text(
                  'Comprar',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () {
                  setState(() {
                    show = false;
                  });
                },
                child: Text(
                  'Coleção',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
                ),
                onPressed: () async {
                  await getpath();
                  setState(() {});
                },
                icon: const Icon(Icons.update,
                    color: Color(0xFFFFFFFF), size: 25), // The icon to display
              ),
            ],
          ),
          if (show == true && buypath.length > 0)
            ListEventbuy(getfund: getfund, userpath: buypath, userbuy: ownpath),
          if (show == false && ownpath.length > 0)
            ListEventClose(userpath: ownpath),
        ],
      ),
    );
  }
}
