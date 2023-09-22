// models/model_item_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_item.dart';

class ItemProvider with ChangeNotifier {
  late CollectionReference itemsReference;
  List<Item> items = [];

  ItemProvider({reference}) {
    itemsReference = reference ??
        FirebaseFirestore.instance.collection('items');
  }

  Future<void> fetchItems() async {
    items = await itemsReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Item.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
    }

  Future<void> incrementPrice(int index) async {
    // Increase the price of the item at the given index.
    items[index].price++;

    // Update the item in Firestore.
    await itemsReference.doc(items[index].id).update({
      'price': FieldValue.increment(1),
      // Add any other fields that should be updated here...
    });

    notifyListeners();

  }

  // Future<void> decrementPrice(int index) async {
  //   // Decrease the price of the item at the given index.
  //   items[index].price--;
  //
  //   // Update the item in Firestore.
  //   await itemsReference.doc(items[index].id).update({
  //     'price': FieldValue.increment(-1),
  //     // Add any other fields that should be updated here...
  //   });
  //
  //   notifyListeners();
  //
  // }

  Future<void> decrementAllPrices() async {
    for (var item in items) {
      // Decrease the price of the local item.
      item.price--;

      // Update the price of the corresponding item in Firestore.
      await itemsReference.doc(item.id).update({
        'price': FieldValue.increment(-1),
        // Add any other fields that should be updated here...
      });
    }

    notifyListeners();
  }


}