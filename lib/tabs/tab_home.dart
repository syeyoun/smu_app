// tabs/tab_home.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:test_1/screens/screen_qr.dart';
import 'package:test_1/models/model_hash.dart';

class TabHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final hashProvider = Provider.of<HashProvider>(context);

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
        } else {
          return Stack(
              children: [
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1,
                    ),
                    itemCount: itemProvider.items.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Positioned(
                              top: 100, // replace with actual values
                              left: 100, // replace with actual values
                              child:
                              Text (
                                  itemProvider.items[index].open ? '열려있어요!' : '닫혀있어요!',
                                  style:
                                  TextStyle(fontSize :(25),color :(Color((0xff0E207F))))
                              )
                          ),
                          Positioned(
                              top: 200, // replace with actual values
                              left: 100, // replace with actual values
                              child :
                              Text (
                                  itemProvider.items[index].price.toString()+'명이 사용중이에',
                                  style:
                                  TextStyle(fontSize:(25),color:(Color((0xff0E207F))))
                              )
                          ),
                          Positioned(
                              top: 300, // replace with actual values
                              left: 100, // replace with actual values
                              child :
                              Text (
                                  itemProvider.items[index].card.toString()+'이 카드를 가지고 있어요!',
                                  style:
                                  TextStyle(fontSize:(25),color:(Color((0xff0E207F))))
                              )
                          ),
                        ],
                      );
                    }
                ),
                Positioned(
                  // top:<top-value>,   // replace with actual value
                  left:100,   // replace with actual value
                  // right:<right-value>,   // replace with actual value or remove this line if not needed.
                  bottom:100,   // replace with actual value or remove this line if not needed.
                  child:
                  Container (
                    width :(200),// desired width
                    height :(60),// desired height

                    child:ElevatedButton (
                        style:ElevatedButton.styleFrom (
                          backgroundColor :(Color(0xff0E207F)),
                          shape:(RoundedRectangleBorder(borderRadius:(BorderRadius.circular(30.0)))),
                        ) ,
                        onPressed:(() async
                        {
                          await hashProvider.getQRNumFromFirebase();
                          Navigator.push(context ,MaterialPageRoute(builder:(context)=>ScannerScreen()));}),
                        child:
                        Text('QR스캐너!',style:
                        TextStyle(fontSize:25,color:Colors.white),
                        )
                    ),
                  ),
                )
              ]
          );
        }
      },
    );
  }
}
