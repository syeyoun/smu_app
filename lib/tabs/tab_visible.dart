// tabs/tab_home.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';

class TabVisible extends StatefulWidget {
  @override
  _TabVisibleState createState() => _TabVisibleState();
}

// class _TabVisibleState extends State<TabVisible> {
//   Map<int, bool> clickedItems = {};
//
//   @override
//   Widget build(BuildContext context) {
//     final itemProvider = Provider.of<ItemProvider>(context);
//     return FutureBuilder(
//       future: itemProvider.fetchItems(),
//       builder: (context, snapshot) {
//         if (itemProvider.items.length == 0) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           // Optionally handle error here...
//           return Text('An error occurred');
//         } else {
//           return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1 / 1.5,
//               ),
//               itemCount: itemProvider.items.length,
//               itemBuilder: (context, index) {
//                 bool isClicked = clickedItems[index] ?? false;
//                 return GridTile(
//                     child: InkWell(
//                       onTap: isClicked ? null : () {
//                         setState(() {
//                           clickedItems[index] = true;
//                           itemProvider.items[index].price++;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         child:
//                         isClicked ?
//                         Text("사용중!", style:
//                         TextStyle(fontSize:
//                         isClicked ?16 :20,color:
//                         Colors.red),
//                         )
//                             :
//                         Column(crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                           children:[
//                             Text(itemProvider.items[index].price.toString()+'명',
//                               style:
//                               TextStyle(fontSize:
//                               isClicked ?16 :20,color:
//                               Colors.red),
//                             ),
//                             ElevatedButton(onPressed:null ,child :Text('출석!'))
//                           ],
//                         ),
//                       ),
//                     )
//                 );
//               }
//           );
//         }
//       },
//     );
//   }
// }

// class _TabVisibleState extends State<TabVisible> {
//   Map<int, bool> clickedItems = {};
//
//   @override
//   Widget build(BuildContext context) {
//     final itemProvider = Provider.of<ItemProvider>(context);
//     return FutureBuilder(
//       future: itemProvider.fetchItems(),
//       builder: (context, snapshot) {
//         if (itemProvider.items.length == 0) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           // Optionally handle error here...
//           return Text('An error occurred');
//         } else {
//           return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1 / 1.5,
//               ),
//               itemCount: itemProvider.items.length,
//               itemBuilder: (context, index) {
//                 bool isClicked = clickedItems[index] ?? false;
//                 return GridTile(
//                     child: InkWell(
//                       onTap: isClicked ? null : () async {
//                         setState(() {
//                           clickedItems[index] = true;
//                           // itemProvider.items[index].price++;
//                         });
//                         await itemProvider.incrementPrice(index); // Call incrementPrice() here.
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         child:
//                         Column(crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                           children:[
//                             Text(itemProvider.items[index].price.toString()+'명',
//                               style:
//                               TextStyle(fontSize:
//                               isClicked ?16 :20,color:
//                               Colors.red),
//                             ),
//                             isClicked ?
//                             Text("사용중!", style:
//                             TextStyle(fontSize:
//                             isClicked ?16 :20,color:
//                             Colors.red),
//                             )
//                                 :
//                             ElevatedButton(onPressed:null ,child :Text('출석!'))
//                           ],
//                         ),
//                       ),
//                     )
//                 );
//               }
//           );
//         }
//       },
//     );
//   }
// }
class _TabVisibleState extends State<TabVisible> {
  Map<int, bool> clickedItems = {};

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
          return Text('An error occurr
        } else {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) {
                bool isClicked = clickedItems[index] ?? false;
                return GridTile(
                    child: InkWell(
                      onTap: isClicked ? null : () async { // Make this callback async.
                        setState(() {
                          clickedItems[index] = true;
                        });
                        await itemProvider.incrementPrice(index); // Call incrementPrice() here.
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child:
                        Column(crossAxisAlignment:
                        CrossAxisAlignment.start,
                          children:[
                            Text(itemProvider.items[index].price.toString()+'명',
                              style:
                              TextStyle(fontSize:
                              isClicked ?16 :20,color:
                              Colors.red),
                            ),
                            isClicked ?
                            Text("사용중!", style:
                            TextStyle(fontSize:
                            isClicked ?16 :20,color:
                            Colors.red),
                            )
                                :
                            ElevatedButton(onPressed:null ,child :Text('출석!'))
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

