import 'package:education/actions.dart';
import 'package:education/authentication.dart';
import 'package:education/ui/widgets/button.dart';
import 'package:education/ui/main_screen.dart';
import 'package:education/ui/widgets/textFiled.dart';
import 'package:flutter/material.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:education/ui/login.dart';
import 'package:education/ui/selectRole.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:education/appstate.dart';
import 'package:education/reducers.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;
  LoginScreen(this.isAdmin);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loginController = new TextEditingController();
  var passwordController = new TextEditingController();
  var auth = new Auth();
  Color color = Colors.white;
  var valid = false;
  var data;
  Worker person;
  @override
  void initState() {
    // TODO: implement initState
    if (!widget.isAdmin) {
      final databaseReference = FirebaseDatabase.instance.reference();
      var workers = new List<Worker>();
      //String status = 'connection';

      databaseReference.child('groups').once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          data = snapshot;
          for (int i = 0; i < snapshot.value.length; i++) {
            var group = snapshot.value[i];
            for (int j = 0; j < group['workers'].length; j++) {
              var worker = group['workers'][j];
              print(worker['pwd']);
            }
          }
        }
      });
    }

    super.initState();
  }

  bool _findUser() {
    for (int i = 0; i < data.value.length; i++) {
      var group = data.value[i];
      for (int j = 0; j < group['workers'].length; j++) {
        var worker = group['workers'][j];
        if (loginController.text == worker['login'] &&
            passwordController.text == worker['pwd']) {
          person = Worker(
            date: worker['date'],
            id: worker['id'],
            login: worker['login'],
            name: worker['name'],
            number: worker['number'],
            pwd: worker['pwd'],
            work: worker['work'],
          );
          print(person);
          valid = false;
          StoreProvider.of<AppState>(context).dispatch(WorkerAction(person));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  isAdmin: false,
                ),
              ));
          return true;
        }
        print(worker['pwd']);
      }
    }
    valid = true;
    passwordController.clear();
    loginController.clear();
    setState(() {});
    //   final errorMsg = ;
    return false;
  }

  _login(String email, String password) async {
    final status =
        await FirebaseAuthHelper().login(email: email, pass: password);
    if (status == AuthResultStatus.successful) {
      valid = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(isAdmin: true),
        ),
      );
    } else {
      valid = true;
      passwordController.clear();
      loginController.clear();
      setState(() {});
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Image.asset('assets/images/main.png'),
                  InputTextFiled(
                      errorText: valid ? 'Неправильный логин или пароль' : '',
                      label: 'Логин',
                      controller: loginController,
                      obscure: false),
                  InputTextFiled(
                    label: 'Пароль',
                    controller: passwordController,
                    obscure: true,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  BottomButton(
                      name: 'ВОЙТИ',
                      handler: () {
                        widget.isAdmin
                            ? _login(
                                loginController.text, passwordController.text)
                            : _findUser();
                      }),
                ],
              ),
            ),
          );
        });
  }
}
