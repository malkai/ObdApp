import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import '../dataBaseClass/obdRawData.dart';

abstract class Repository {
  static final FirebaseFirestore _dbInstance = FirebaseFirestore.instance;

  static final String _collection = 'dataPoints';

  static void add(Userdata user) {
    _dbInstance
        .collection(_collection)
        .doc(user.name)
        .collection(user.uservehicle.vin)
        .add(user.toJson());
  }
}
