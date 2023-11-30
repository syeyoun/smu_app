// // screens/screen_login.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test_1/models/model_auth.dart';
// import 'package:test_1/models/model_login.dart';
//
// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => LoginModel(),
//         child: Scaffold(
//           appBar: AppBar(),
//           body: Column(
//             children: [
//               EmailInput(),
//               PasswordInput(),
//               LoginButton(),
//               Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Divider(
//                   thickness: 1,
//                 ),
//               ),
//               RegisterButton(),
//             ],
//           ),
//         ));
//   }
// }
//
// class EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final login = Provider.of<LoginModel>(context, listen: false);
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: TextField(
//         onChanged: (email) {
//           login.setEmail(email);
//         },
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//           labelText: 'email',
//           helperText: '',
//         ),
//       ),
//     );
//   }
// }
//
// class PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final login = Provider.of<LoginModel>(context, listen: false);
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: TextField(
//         onChanged: (password) {
//           login.setPassword(password);
//         },
//         obscureText: true,
//         decoration: InputDecoration(
//           labelText: 'password',
//           helperText: '',
//         ),
//       ),
//     );
//   }
// }
//
// class LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authClient =
//     Provider.of<FirebaseAuthProvider>(context, listen: false);
//     final login = Provider.of<LoginModel>(context, listen: false);
//
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.7,
//       height: MediaQuery.of(context).size.height * 0.05,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//         ),
//         onPressed: () async {
//           await authClient
//               .loginWithEmail(login.email, login.password)
//               .then((loginStatus) {
//             if (loginStatus == AuthStatus.loginSuccess) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(SnackBar(
//                     content:
//                     Text('welcome! ' + authClient.user!.email! + ' ')));
//               Navigator.pushReplacementNamed(context, '/index');
//             } else {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(SnackBar(content: Text('login fail')));
//             }
//           });
//         },
//         child: Text('Login'),
//       ),
//     );
//   }
// }
//
// class RegisterButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed('/register');
//         },
//         child: Text(
//           'Regist by email',
//         ));
//   }
// }
// screens/screen_login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_login.dart';
import 'package:test_1/models/model_permission.dart';
import 'package:test_1/models/model_hash.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginModel(),
        child: Scaffold(
          appBar: AppBar(
              title: Text("로그인"),
              centerTitle: true,
              backgroundColor: Color(0xff0E207F)),
          body: Column(
            children: [
              EmailInput(),
              PasswordInput(),
              LoginButton(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              RegisterButton(),
            ],
          ),
        ));
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (email) {
          login.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'email',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (password) {
          login.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password',
          helperText: '',
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final login = Provider.of<LoginModel>(context, listen: false);
    final userPermissionProvider = Provider.of<UserPermissionProvider>(context, listen: false); // 추가된 부분
    final hashProvider = Provider.of<HashProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0E207F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .loginWithEmail(login.email, login.password)
              .then((loginStatus) async { // async 추가
            if (loginStatus == AuthStatus.loginSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('welcome! ' +
                        authClient.user!.email! +
                        ' '))); //email자리에 username 넣기

              // 권한 부여 과정 추가
              if(authClient.user != null && authClient.user!.email != null) {
                userPermissionProvider.email = authClient.user!.email!;
                await userPermissionProvider.updateAccess();
              }

              if( hashProvider.qrnum == null){
                await hashProvider.getQRNumFromFirebase();
              }

              Navigator.pushReplacementNamed(context, '/index');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('login fail')));
            }
          });
        },
        child: Text('로그인'),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        },
        child: Text('회원가입', style: TextStyle(color: Color((0xff0E207F)))));
  }
}
