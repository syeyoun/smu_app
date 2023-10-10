// tabs/tab_home.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:test_1/screens/screen_qr.dart';

class TabHome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    return FutureBuilder(
      future: itemProvider.fetchItems(),
      builder: (context, snapshot) {
        if (itemProvider.items.length == 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Optionally handle error here...
          return Text('An error occurred');
    // return FutureBuilder(
    //   future: itemProvider.fetchItems(),
    //   builder: (context, snapshots) {
    //     if (itemProvider.items.length == 0) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
        } else {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) {
                return GridTile(
                    child: InkWell(
                      onTap: () {       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScannerScreen()),
                      ); },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image.network(itemProvider.items[index].imageUrl),
                            // Text(
                            //   itemProvider.items[index].open ? '열림' : '닫힘',
                            //   style: TextStyle(fontSize: 20),
                            // ),
                            Text(itemProvider.items[index].open ? '열림' : '닫힘',
                              style: TextStyle(fontSize: 16, color: Colors.red),)

                          ],
                        ),
                      ),
                    )
                );
              }
          );
        }
      },
    );
  }
}