// models/model_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Item {
  late String id;
  late int price;
  // late String title;
  // late bool isIncreased; //추가
  // late Timestamp lastIn;
  // late String id_2;
  late bool open;
  // late int t_price;
  late String card;
  // late String username;

  Item({
    required this.id,
    required this.price,
    // required this.title,
    // required this.isIncreased,
    required this.open,
    required this.card,
    // required this.id_2,
    // required this.lastIn,
    // required this.t_price,
    // required this.username,

  });

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    price = data['price'];
    card = data['card'];
    // title = data['title'];
    // isIncreased = data['isIncreased']; // 추가
    open = data['open'];
    // id_2 = data['id_2'];
    // username = data['username'];
    // lastIn = data['lastIn'];
    // t_price = data['t_price'];
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    price = data['price'];
    // title = data['title'];
    card = data['card'];
    // isIncreased = data['isIncreased'];
    open = data['open'];
    // username = data['username'];

    // lastIn=data['lastIn'];
    // t_price = data['t_price'];
    // id_2 = data['id_2'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'price': price,
      // 'title': title,
      // 'isIncreased': isIncreased,
      // 'id_2': id_2,
      'open': open,
      'card': card,
      // 'username' : username,
      // 'lastIn':lastIn,
      // 't_price':t_price,
    };
  }
}
// class Item {
//
//   late String id;
//   late int price;
//   late String title;
//   late bool isIncreased; //추가
//
//   Item({
//     required this.id,
//     required this.price,
//     required this.title,
//   });
//
//   Item.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     id = snapshot.id;
//     price = data['price'];
//     title = data['title'];
//     isIncreased = data['isIncreased']; // 추가
//   }
//
//   Map<String, dynamic> toSnapshot() {
//     return {'id': id, 'price': price, 'title': title, 'isIncreased': isIncreased};
//   }
//}