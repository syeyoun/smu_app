import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_1/models/model_item.dart';

class TabVisible extends StatefulWidget {
  @override
  _TabVisibleState createState() => _TabVisibleState();
}

class _TabVisibleState extends State<TabVisible> {
  late Item item;

  @override
  void initState() {
    super.initState();
    fetchItemFromFirestore(); // Firestore에서 아이템 정보 가져오기
  }

  void fetchItemFromFirestore() async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('items').doc('0CCecNjZr0QB6h2BQ5TG').get();
    // await FirebaseFirestore.instance.collection('items').doc('QxTeoE9yPeSq2b2AsN8c').get();

    if (snapshot.exists) {
      setState(() {
        item = Item.fromSnapshot(snapshot);
      });
    }
  }

  void togglePrice() async {
    if (item != null) {

      bool isIncreased = item.isIncreased;

      setState(() {
        item.price += isIncreased ? 1 : -1; // isIncreased가 true이면 +1, false이면 -1
        isIncreased = !item.isIncreased; // 토글 상태 변경
      });

      await FirebaseFirestore.instance.collection('items').doc(item.id).update({
        'price': item.price,
        'isIncreased': item.isIncreased,
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('인원: ${item?.title ?? ""}'),
            Text('${item?.price.toString() ?? ""}명 사용중'),
            ElevatedButton(
              onPressed: () => togglePrice(),
              child: Text("출석?"),
            ),
          ],
        ),
      ),
    );
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
// }
