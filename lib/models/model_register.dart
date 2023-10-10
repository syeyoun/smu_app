// // models/model_register.dart
// import 'package:flutter/material.dart';
//
// class RegisterModel extends ChangeNotifier {
//   String email = "";
//   String password = "";
//   String passwordConfirm = "";
//
//   void setEmail(String email) {
//     this.email = email;
//     notifyListeners();
//   }
//
//   void setPassword(String password) {
//     this.password = password;
//     notifyListeners();
//   }
//
//   void setPasswordConfirm(String passwordConfirm) {
//     this.passwordConfirm = passwordConfirm;
//     notifyListeners();
//   }
// }
// models/model_register.dart
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String username = "";
  String studentid = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";

  void setusername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setstudentid(String studentid) {
    this.studentid = studentid;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setPasswordConfirm(String passwordConfirm) {
    this.passwordConfirm = passwordConfirm;
    notifyListeners();
  }
}