// // screens/screen_regist.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test_1/models/model_auth.dart';
// import 'package:test_1/models/model_register.dart';
//
// class RegisterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => RegisterModel(),
//       child: Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           children: [
//             EmailInput(),
//             PasswordInput(),
//             PasswordConfirmInput(),
//             RegistButton()
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final register = Provider.of<RegisterModel>(context, listen: false);
//     return Container(
//       padding: EdgeInsets.all(5),
//       child: TextField(
//         onChanged: (email) {
//           register.setEmail(email);
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
//     final register = Provider.of<RegisterModel>(context);
//     return Container(
//       padding: EdgeInsets.all(5),
//       child: TextField(
//         onChanged: (password) {
//           register.setPassword(password);
//         },
//         obscureText: true,
//         decoration: InputDecoration(
//           labelText: 'password',
//           helperText: '',
//           errorText: register.password != register.passwordConfirm ? 'Password incorrect' : null,
//         ),
//       ),
//     );
//   }
// }
//
// class PasswordConfirmInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final register = Provider.of<RegisterModel>(context, listen: false);
//     return Container(
//       padding: EdgeInsets.all(5),
//       child: TextField(
//         onChanged: (password) {
//           register.setPasswordConfirm(password);
//         },
//         obscureText: true,
//         decoration: InputDecoration(
//           labelText: 'password confirm',
//           helperText: '',
//         ),
//       ),
//     );
//   }
// }
//
// class RegistButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authClient =
//     Provider.of<FirebaseAuthProvider>(context, listen: false);
//     final register = Provider.of<RegisterModel>(context, listen: false);
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
//               .registerWithEmail(register.email, register.password)
//               .then((registerStatus) {
//             if (registerStatus == AuthStatus.registerSuccess) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(content: Text('Regist Success')),
//                 );
//               Navigator.pop(context);
//             } else {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(content: Text('Regist Fail')),
//                 );
//             }
//           });
//         },
//         child: Text('Regist'),
//       ),
//     );
//   }
// }
// screens/screen_regist.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_register.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
            title: Text("회원가입"),
            centerTitle: true,
            backgroundColor: Color(0xff0E207F)),
        body: Column(
          children: [
            UserName(),
            Student_ID(),
            EmailInput(),
            PasswordInput(),
            PasswordConfirmInput(),
            RegistButton()
          ],
        ),
      ),
    );
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (username) {
          register.setusername(username);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: '이름',
          helperText: '',
        ),
      ),
    );
  }
}

class Student_ID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (studentid) {
          register.setstudentid(studentid);
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          labelText: '학번',
          helperText: '',
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (email) {
          register.setEmail(email);
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
    final register = Provider.of<RegisterModel>(context);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (password) {
          register.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: '비밀번호',
          helperText: '',
          errorText: register.password != register.passwordConfirm
              ? '비밀번호가 일치하지않습니다'
              : null,
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (password) {
          register.setPasswordConfirm(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: '비밀번호 확인',
          helperText: '',
        ),
      ),
    );
  }
}

class RegistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final register = Provider.of<RegisterModel>(context, listen: false);
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
              .registerWithEmail(register.email, register.password, register.username, register.studentid)
              .then((registerStatus) {
            if (registerStatus == AuthStatus.registerSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('회원가입 완료')),
                );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('회원가입 실패')),
                );
            }
          });
        },
        child: Text('위 정보로 회원가입하기'),
      ),
    );
  }
}