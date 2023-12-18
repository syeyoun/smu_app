// models/model_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String id;
  late int price;
  late bool open;
  late String card;

  Item({
    required this.id,
    required this.price,
    required this.open,
    required this.card,

  });

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    price = data['price'];
    card = data['card'];
    open = data['open'];
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    price = data['price'];
    card = data['card'];
    open = data['open'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'price': price,
      'open': open,
      'card': card,
    };
  }
}
