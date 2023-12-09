// main.dart
// import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/firebase_options.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_hash.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:test_1/models/model_time.dart';
import 'screens/screen_splash.dart';
import 'screens/screen_index.dart';
import 'screens/screen_login.dart';
import 'screens/screen_register.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_1/models/model_permission.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final notifications = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Duration _logoutDuration = Duration(seconds: 20);

// void setLogoutDuration (Duration duration) async {
//   _logoutDuration = duration;
// }

// initNotification() async {
//
//   // var androidSetting = AndroidInitializationSettings('app_icon');
//
//   var initializationSettings = InitializationSettings(
//       // android: androidSetting,
//   );
//   await notifications.initialize(
//     initializationSettings,
//     //onSelectNotification: 함수명추가
//   );
// }

// Future<void> initializeRQR() async {
//   var r_qr = await hashProvider.getQRNumFromFirebase();
//   // print(r_qr);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initNotification();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (context) => HashProvider()),
        ChangeNotifierProvider(create: (context) => LogoutTimerProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => QRScannerProvider()),
        ChangeNotifierProvider(create: (context) => TabState()),
        ChangeNotifierProvider(create: (_) => UserPermissionProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: MyApp(),
        // Define the '/login' route here as well
        routes: {
          '/index': (context) => IndexScreen(),
          '/login': (context) => LoginScreen(),
          '/splash': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 사용자의 로그인 상태를 감지합니다.
    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      if (user != null && user.email != null) {
        print('User is signed in!');
        var userPermissionProvider = Provider.of<UserPermissionProvider>(context, listen: false);
        while (user.email == null) {
          await Future.delayed(Duration(seconds: 1));
        }

        // 이메일이 설정되면 권한을 부여합니다.
        userPermissionProvider.email = user.email!;
        await userPermissionProvider.updateAccess();
      } else {
        print('User is currently signed out!');
      }
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => LogoutTimerProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => HashProvider()),
        ChangeNotifierProvider(create: (_) => QRScannerProvider()),
        ChangeNotifierProvider(create: (_) => TabState()),
        ChangeNotifierProvider(create: (_) => UserPermissionProvider()),

      ],
      child: MaterialApp(
        title: 'Chamber for CS students',
        routes: {
          '/index': (context) => IndexScreen(),
          '/login': (context) => LoginScreen(),
          '/splash': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
        },
        initialRoute: '/splash',
      ),
    );
  }
}

Future<void> logoutAndRedirect() async {
  // navigatorKey.currentContext 가 null 인 경우 처리
  // if (navigatorKey.currentContext == null) {
  //   print('Navigator key is not currently associated with any widget.');
  //   return;
  // }
  // ScaffoldMessenger.of(navigatorKey.currentContext!)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar(SnackBar(content: Text('logout!')));

  // GlobalKey를 사용하여 Navigator 상태에 접근
  navigatorKey.currentState!.pushReplacementNamed('/login');
}