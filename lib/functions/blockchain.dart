import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:obdapp/dataBaseClass/blockchainid.dart';

class blockchain {
  Future<bool> checkconnection(String site) async {
    try {
      final result = await InternetAddress.lookup(site);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}
    return false;
  }

  Future<String> getserver(String info) async {
    final url = info; // Example API endpoint

    try{
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Request successful, process the response body
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      // Request failed, handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }}
    catch (e){
      print("Erro ao enviar");    
      return "";
      }
  }


    Future<void> getEvent(String info) async {
    final url = info; // Example API endpoint

    try{
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Request successful, process the response body
      var data = jsonDecode(response.body);
      print(data);
     
    } else {
      // Request failed, handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }}
    catch (e){
      print("Erro ao enviar");    
     
      }
  }

  Future<Response> sendata(var helplist) async {
    late Box userdata;

    userdata = await Hive.openBox<wallet>('wallet');

    wallet user = userdata.getAt(0);

    Map<String, dynamic> data = {
      'Data': DateTime.now().toString(),
      'wallet': user.add,
      'data': helplist,
    };

    final uri = Uri.parse("${user.site}/process/vehicledata");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json', // Indicate what kind of response you expect
    };
    //final enCodedJson = utf8.encode(jsonEncode(body.toString()));
    //final gZipJson = gzip.encode(enCodedJson);
    //final base64Json = base64.encode(gZipJson);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }
}
