// models/model_time.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class HashProvider with ChangeNotifier {
  String _hashValue = '';

  String get hashValue => _hashValue;

  void updateHash(String value) {
    _hashValue = value;
    notifyListeners();
  }
}