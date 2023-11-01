import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:path_provider/path_provider.dart';

import '../dataBaseClass/obdRawData.dart';

// use elliptic curves
EllipticCurve ec = getP256();

void generateKeys() async {
  var priv = ec.generatePrivateKey();
  var pub = priv.publicKey;

  writePrivKey(priv);
  writePubKey(pub);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _pubKeyFile async {
  final path = await _localPath;
  return File('$path\\pubkey.pem');
}

Future<File> get _privKeyFile async {
  final path = await _localPath;
  return File('$path\\privkey.pem');
}

Future<File> writePubKey(PublicKey key) async {
  final file = await _pubKeyFile;
  return file.writeAsString(key.toString());
}

Future<File> writePrivKey(PrivateKey key) async {
  final file = await _privKeyFile;
  return file.writeAsString(key.toString());
}

Future<String> readPubKey() async {
  try {
    final file = await _pubKeyFile;

    // Read the file
    final key = await file.readAsString();

    return key;
  } catch (e) {
    // If encountering an error, return empty string
    return '';
  }
}

Future<String> readPrivKey() async {
  try {
    final file = await _privKeyFile;

    // Read the file
    final key = await file.readAsString();

    return key;
  } catch (e) {
    // If encountering an error, return empty string
    return '';
  }
}

Future<bool> hasKeys() async {
  String? strPrivKey;
  strPrivKey = await readPrivKey().then((value) => value);
  var hasKeys = strPrivKey != "" && strPrivKey != null;

  return hasKeys;
}

//verificar uma chave universal por usuario

Future<Signature> sign(UserDataProcess data) async {
  Signature sig;

  await hasKeys().then((result) {
    if (!result) {
      generateKeys();
    }
  });

  sig = await readPrivKey().then((strPrivKey) {
    PrivateKey privKey;
    privKey = PrivateKey.fromHex(ec, strPrivKey);
    List list = [];
    list.add(data);
    final dataJSON = utf8.encode(jsonEncode(list));
    var hash = sha256.convert(dataJSON);
    return signature(privKey, hash.bytes);
  });

  return sig;
}

Future<bool> verifySignature(Map data, Signature sig) async {
  final dataJSON = utf8.encode(jsonEncode(data));
  var hash = sha256.convert(dataJSON);
  var result = await readPubKey().then((strPubKey) {
    PublicKey pub;
    pub = PublicKey.fromHex(ec, strPubKey);
    return verify(pub, hash.bytes, sig);
  });
  return result;
}
