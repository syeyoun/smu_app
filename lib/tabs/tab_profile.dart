// tabs/tab_profile.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';

class TabProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Profile"),
          LoginOutButton(itemIndex: 3),
        ],
      ),
    );
  }
}

class LoginOutButton extends StatelessWidget {

  final int itemIndex;
  LoginOutButton({required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    // final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context, listen: false);
    return TextButton(
        onPressed: () async {
          //decrease
          await itemProvider.decrementAllPrices();
          logoutTimerProvider.startLogoutCountdown();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('logout!')));
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: Text('logout'));
  }
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
//                       onTap: isClicked ? null : () async { // Make this callback async.
//                         setState(() {
//                           clickedItems[index] = true;
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