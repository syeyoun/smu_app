// main.dart
// import 'dart:js';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (context) => TabState()),
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => LogoutTimerProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => HashProvider()),
        ChangeNotifierProvider(create: (_) => QRScannerProvider()),
        ChangeNotifierProvider(create: (_) => TabState()),
      ],
      child: MaterialApp(
        title: 'Flutter Shopping mall',
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
  if (navigatorKey.currentContext == null) {
    print('Navigator key is not currently associated with any widget.');
    return;
  }

  // ScaffoldMessenger.of(navigatorKey.currentContext!)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar(SnackBar(content: Text('logout!')));

  // GlobalKey를 사용하여 Navigator 상태에 접근
  navigatorKey.currentState!.pushReplacementNamed('/login');
}