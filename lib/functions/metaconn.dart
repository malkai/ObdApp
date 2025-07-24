import 'dart:convert';

import 'package:reown_walletkit/reown_walletkit.dart';
import 'package:reown_walletkit/walletkit_impl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class meteconnect {
  Future<void> wallet() async {
    // AppKit instance
   

  

    // AppKit Modal instance
  
    
  }

  Future<void> _launchurl() async {
    const dappUrl = 'http://metamask.app.link/dapp/192.168.1.152/blockchain';
    const metamaskAppDeepLink = 'https://metamask.app.link/dapp/' + dappUrl;
    final Uri launchUri = Uri(
      scheme: 'metamask',
    );
    await launchUrl(launchUri);
  }

  Future<Map<String, dynamic>> getAuth() async {
    final response = await http
        .get(
          Uri.parse('http://192.168.1.152/jwtserver/login'),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void login() async {
    var auth = await getAuth();
    print(auth['token']);
    wallet();
  }

  void sendData() {}
}
