// models/model_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// models/model_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus {
  registerSuccess,
  registerFail,
  loginSuccess,
  loginFail
}

class FirebaseAuthProvider with ChangeNotifier {
  FirebaseAuth authClient;
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> allowedTabs = [];

  FirebaseAuthProvider({auth}) : authClient = auth ?? FirebaseAuth.instance;

  Future<AuthStatus> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await authClient
          .createUserWithEmailAndPassword(email: email, password: password);
      return AuthStatus.registerSuccess;
    } catch (e) {
      return AuthStatus.registerFail;
    }
  }

  Future<AuthStatus> loginWithEmail(String email, String password) async {
    try {
      await authClient.signInWithEmailAndPassword(
          email: email, password: password).then(
              (credential) async {
            user = credential.user;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLogin', true);
            prefs.setString('email', email);
            prefs.setString('password', password);

            // 로그인 후 권한 정보 불러오기
            await fetchPermissions();
          }
      );
      return AuthStatus.loginSuccess;
    } catch (e) {
      return AuthStatus.loginFail;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('email', '');
    prefs.setString('password', '');
    user = null;
    allowedTabs = [];
    await authClient.signOut();
  }

  Future<void> fetchPermissions() async {
    if (user != null) {
      DocumentSnapshot snapshot = await firestore.collection('items1').doc(
          user!.uid).get();
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['allowedTabs'] != null) {
        allowedTabs = List<String>.from(data['allowedTabs'] as List<dynamic>);
      }
    }
  }
}