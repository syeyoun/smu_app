// models/model_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Item {
  late String id;
  late int price;
  late String title;
  late bool isIncreased; //추가
  //
  // late String id_2;
  late bool open;

  Item({
    required this.id,
    required this.price,
    required this.title,
    required this.isIncreased,
    //
    required this.open,
    // required this.id_2,
  });

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    price = data['price'];
    title = data['title'];
    isIncreased = data['isIncreased']; // 추가
    //
    open = data['open'];
    // id_2 = data['id_2'];
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    price = data['price'];
    title = data['title'];

    isIncreased = data['isIncreased'];
    open = data['open'];
    // id_2 = data['id_2'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'price': price,
      'title': title,
      'isIncreased': isIncreased,
      //
      // 'id_2': id_2,
      'open': open,
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