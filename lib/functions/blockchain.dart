import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:web3dart/web3dart.dart';

class blockchain {
  Future<bool> checkServerStatus(String serverUrl) async {
    try {
      // Send a GET request to a known endpoint (e.g., a health check endpoint)
      final response = await http
          .get(Uri.parse(serverUrl))
          .timeout(const Duration(seconds: 5));

      // Check if the status code is a success (e.g., 200 OK)
      if (response.statusCode == 200) {
        return true; // Server is running and reachable
      } else {
        return false; // Server responded, but not with a success code
      }
    } catch (e) {
      // Handle exceptions like SocketException (network unreachable),
      // TimeoutException (server took too long to respond), etc.
      print("Server check failed: $e");
      return false; // Server is not reachable
    }
  }

  Future<dynamic> getserver(String info) async {
    final url = info; // Example API endpoint

    //try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Request successful, process the response body
      var data = json.decode(response.body);

      return data;
    } else {
      // Request failed, handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    //} catch (e) {
    //  print(e);
    //  return "";
    // }
  }

  void getscore(String useradd) async {
    Box userdata = await Hive.openBox<wallet>('wallet');
    wallet user = userdata.getAt(0);
    Box userscore = await Hive.openBox<UserScore>('score');
    blockchain connect = blockchain();
    String help = user.site;

    Map<String, dynamic> data = {
      'wallet': useradd,
    };
    if (user.blockchain) {
      if (await connect.getserver(help + "/jwtserver/") != "") {
        String resp = await connect.postEvent("$help/jwtserver/get/score", data);
        final decoded = json.decode(resp);

        if (decoded != "contrato não existente") {
          UserScore score =
              UserScore(conf: decoded[0], comp: decoded[1], freq: decoded[2]);
          if (userscore.isEmpty) {
            userscore.add(score);
          } else {
            userscore.put(0, score);
          }
        } else {
          UserScore score = UserScore(conf: "0", comp: "0", freq: "0");
          if (userscore.isEmpty) {
            userscore.add(score);
          } else {
            userscore.put(0, score);
          }
        }
      } else {
        UserScore score = UserScore(conf: "0", comp: "0", freq: "0");
        if (userscore.isEmpty) {
          userscore.add(score);
        } else {
          userscore.put(0, score);
        }
      }
    }
  }

  void createuser() async {
    final storage = FlutterSecureStorage();
    var aux2 = await storage.read(key: 'privatekey');

    print(aux2);

    if (aux2 == null) {
      wallet user = wallet(add: "", name: "");

      // Use a cryptographically secure random number generator.
      // DO NOT use `Random()` as it is predictable and insecure.
      var rng = Random.secure();

      // Generate a new, random private key using the secure random generator.
      EthPrivateKey newPrivateKey = EthPrivateKey.createRandom(rng);

      // Access the private key in its hexadecimal string format.
      // This is the 32-byte (64-character) hex string.
      String privateKeyHex =
          newPrivateKey.privateKeyInt.toRadixString(16).padLeft(64, '0');

      // The 'credentials' object holds the private key and can derive
      // the public key and address from it.
      await storage.write(key: 'privatekey', value: privateKeyHex);
      var aux2 = await storage.read(key: 'privatekey');
      String? help = aux2;

      if (help != null) {
        print("OIIIII");
        var credentials = EthPrivateKey.fromHex(help);
        var address = credentials.address;

        await storage.write(key: 'publickey', value: address.hex);

        Box userdata = await Hive.openBox<wallet>('wallet');
        user.add = address.hex.toString();

        if (userdata.isEmpty) {
          userdata.add(user);
        } else {
          await userdata.putAt(0, user);
        }
      }
    }
  }

  Future<void> getpathsbuy(String useradd) async {
    Box userpathc = await Hive.openBox<Event>('buypath' + useradd);
    Box userdata = await Hive.openBox<wallet>('wallet');
    blockchain connect = blockchain();
    wallet user = userdata.getAt(0);
    String help = user.site;

    List<Event> eventlist = [];

    Event eventVar = Event(
        id: -1,
        add: "",
        vin: "",
        date: DateFormat.yMd().parse('06/09/2019'),
        fuel_B: "",
        fuel_E: "",
        usertank: "",
        abastecimento: "");

    Map<String, dynamic> data = {
      'wallet': useradd,
    };
    String resp = await connect.postEvent("$help/jwtserver/get/event/close", data);

    final decoded = json.decode(resp);
    print(decoded);
    if (decoded != "Não existe evento fechado") {
      print("oi");

      for (int i = 0; i < decoded.length; i++) {
        DateFormat inputFormat = DateFormat('MM/dd/yyyy, HH:mm:ss');
        DateTime parsedDate = inputFormat.parse(decoded[i]["date"]);

        eventVar = Event(
            id: int.parse(decoded[i]["idEvent"]),
            add: decoded[i]["contractAddress"],
            vin: decoded[i]["vin"],
            date: parsedDate,
            fuel_B: decoded[i]["fuel_b"],
            fuel_E: decoded[i]["fuel_e"],
            usertank: decoded[i]["usertank"],
            abastecimento: decoded[i]["abastecimento"]);

        eventlist.add(eventVar);
      }

      userpathc.clear();

      if (eventlist.isNotEmpty) {
        if (await connect.getserver(help + "/jwtserver/") != "") {
          String resp =
              await connect.postEvent("$help/jwtserver/get/path/close", data);

          final decoded = json.decode(resp);
          if (decoded.isNotEmpty) {
            List<PathBlockchain> pathlist = [];
            for (int j = 0; j < decoded.length; j++) {
              var aux = decoded[j]["listtrajetos"];
              eventlist[j].value = decoded[j]["value"];
              for (int i = 0; i < aux.length; i++) {
                PathBlockchain pathvar = PathBlockchain(
                    fuel: aux[i]["fuel"],
                    dist: aux[i]["dist"],
                    time: aux[i]["time"],
                    timeless: aux[i]["timeless"]);
                eventlist[j].paths.add(pathvar);
              }
            }
          }
        }
        userpathc.addAll(eventlist);
      }
    } else {
      userpathc.clear();
    }
  }

  Future<void> getpaths(String useradd) async {
    //verificar se existe eventos abertos
    //verificar se existe eventos fechados
    //se não tiver não tentar importar eventos
    Box userpatho = await Hive.openBox<Event>('eventopen');
    Box userpathc = await Hive.openBox<Event>('eventclose');
    Box userdata = await Hive.openBox<wallet>('wallet');
    blockchain connect = blockchain();
    wallet user = userdata.getAt(0);

    Event eventVar = Event(
        id: -1,
        add: "",
        vin: "",
        date: DateFormat.yMd().parse('06/09/2019'),
        fuel_B: "",
        fuel_E: "",
        usertank: "",
        abastecimento: "");

    String help = user.site;

    Map<String, dynamic> data = {
      'wallet': useradd,
    };
    String resp = await connect.postEvent("$help/jwtserver/get/contract", data);

    if (await connect.getserver(help + "/jwtserver/") != "" &&
        resp != "Não existe contrato") {
      String resp = await connect.postEvent("$help/jwtserver/get/event/open", data);
      if (resp != "Não existe evento aberto" ||
          resp != "contrato não existente") {
        try {
          final decoded = json.decode(resp);

          DateFormat inputFormat = DateFormat('MM/dd/yyyy, HH:mm:ss');
          DateTime parsedDate = inputFormat.parse(decoded["date"]);

          //String datee = DateFormat('hh:mm a').format(input);
          eventVar = Event(
              id: int.parse(decoded["idEvent"]) + 1,
              add: decoded["contractAddress"],
              vin: decoded["vin"],
              date: parsedDate,
              fuel_B: decoded["fuel_b"],
              fuel_E: decoded["fuel_e"],
              usertank: decoded["usertank"],
              abastecimento: decoded["abastecimento"]);
        } catch (e) {
          print(e);
        }

        if (eventVar.id != -1) {
          if (await connect.getserver(help + "/jwtserver/") != "") {
            String resp =
                await connect.postEvent("$help/jwtserver/get/path/open", data);
            print("oii");
            print(resp);
            final decoded = json.decode(resp);

            print(decoded);
            print(eventVar);

            if (decoded != "Não há trajetos abertos") {
              if (decoded[0]["listtrajetos"].isNotEmpty) {
                List<PathBlockchain> pathlist = [];

                var aux = decoded[0]["listtrajetos"];
                for (int i = 0; i < aux.length; i++) {
                  PathBlockchain pathvar = PathBlockchain(
                      fuel: aux[i]["fuel"],
                      dist: aux[i]["dist"],
                      time: aux[i]["time"],
                      timeless: aux[i]["timeless"]);

                  pathvar.arrlatlong = aux[i]["pos"];
                  eventVar.paths.add(pathvar);
                }
              }
            }
          }

          if (userpatho.isEmpty) {
            print("userempy");
            userpatho.add(eventVar);
          } else {
            print("add");
            userpatho.putAt(0, eventVar);
          }
        } else {
          userpatho.clear();
        }
      } else {
        print("usuarioa maluco");
      }

      List<Event> eventlist = [];

      eventVar = Event(
          id: -1,
          add: "",
          vin: "",
          date: DateFormat.yMd().parse('06/09/2019'),
          fuel_B: "",
          fuel_E: "",
          usertank: "",
          abastecimento: "");

      resp = await connect.postEvent("$help/jwtserver/get/event/close", data);
      final decoded = json.decode(resp);

      if (decoded != "Não existe evento fechado") {
        for (int i = 0; i < decoded.length; i++) {
          DateFormat inputFormat = DateFormat('MM/dd/yyyy, HH:mm:ss');
          DateTime parsedDate = inputFormat.parse(decoded[i]["date"]);

          eventVar = Event(
              id: int.parse(decoded[i]["idEvent"]),
              add: decoded[i]["contractAddress"],
              vin: decoded[i]["vin"],
              date: parsedDate,
              fuel_B: decoded[i]["fuel_b"],
              fuel_E: decoded[i]["fuel_e"],
              usertank: decoded[i]["usertank"],
              abastecimento: decoded[i]["abastecimento"]);
              

          //print(decoded[i]);
          eventVar.value = "0.0";
          eventlist.add(eventVar);
        }

        userpathc.clear();

        if (eventlist.isNotEmpty) {
          if (await connect.getserver(help + "/jwtserver/") != "") {
            String resp =
                await connect.postEvent("$help/jwtserver/get/path/close", data);

            final decoded = json.decode(resp);
            print(decoded);

            if (decoded.isNotEmpty) {
              List<PathBlockchain> pathlist = [];

              for (int j = 0; j < decoded.length; j++) {
                print(decoded[j]["idevent"]);
                var aux = decoded[j]["listtrajetos"];
                // print(decoded[j]["value"]);
                eventVar.value = decoded[j]["value"];
                print("caminho");
                print(j);
                print(decoded[j]["value"]);

                for (int i = 0; i < aux.length; i++) {
                  print("trajeto");
                  print(i);
                  PathBlockchain pathvar = PathBlockchain(
                      fuel: aux[i]["fuel"],
                      dist: aux[i]["dist"],
                      time: aux[i]["time"],
                      timeless: aux[i]["timeless"]);
                  pathvar.arrlatlong = aux[i]["pos"];
                  int correct = 0;
                  print("tamanho");
                  print(eventlist.length);
                  if (eventlist[correct].id != decoded[j]["idevent"]) {
                    while (eventlist[correct].id != decoded[j]["idevent"] &&
                        correct < eventlist.length - 1) {
                      correct++;
                    }
                  }

                  eventlist[correct].paths.add(pathvar);
                }
              }
            }
          }
          userpathc.addAll(eventlist);
        }
      } else {
        userpathc.clear();
      }
    }
  }

  Future<String> postEvent(String info, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse(info);
      final headers = {
        'Content-Type': 'application/json',
        'Accept':
            'application/json', // Indicate what kind of response you expect
      };
      Response response = await post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return (response.body);
      } else {
        return (response.body);
      }
    } catch (e) {
      print("Erro ao enviar");
      return ("");
    }
  }

  Future<Response> sendata(var helplist) async {
    late Box userdata;
    userdata = await Hive.openBox<wallet>('wallet');
    wallet user = userdata.getAt(0);

    final uri = Uri.parse("${user.site}/jwtserver/send/data/vehicle");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Prepare streamed request
    final request = http.StreamedRequest('POST', uri);

    request.headers.addAll(headers);

    // Start writing JSON structure manually to avoid loading it all at once
    // {
    //   "Data": "...",
    //   "wallet": "...",
    //   "data": [...]
    // }

    request.sink.add(utf8
        .encode('{"Data":"${DateTime.now()}","wallet":"${user.add}","data":['));

    bool first = true;
    for (final item in helplist) {
      if (!first) {
        request.sink.add(utf8.encode(','));
      } else {
        first = false;
      }
      request.sink.add(utf8.encode(json.encode(item)));
      await Future.delayed(Duration.zero); // yield async loop control
    }

    request.sink.add(utf8.encode(']}'));
    await request.sink.close();
    print(request);

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print(response);

    return response;
  }
}


//curl -X POST http://localhost/jwtserver/create/contract
//curl -X POST http://localhost/jwtserver/get/contract
//curl -X POST http://localhost/jwtserver/create/event
//curl -X POST http://localhost/jwtserver/close/event
//curl -X POST http://localhost/jwtserver/close/event
//curl -X POST http://localhost/jwtserver/get/event/open
//curl -X POST http://localhost/jwtserver/create/event
//curl -X POST http://localhost/jwtserver/get/event/open
//./test.sh
//curl -X POST http://localhost/jwtserver/get/event/close
//curl -X POST http://localhost/jwtserver/get/path/open
//curl -X POST http://localhost/jwtserver/get/path/close
//curl -X POST http://localhost/jwtserver/get/score
//curl -X POST http://localhost/jwtserver/get/coin