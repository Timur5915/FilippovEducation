import 'package:education/actions.dart';
import 'package:education/appstate.dart';
import 'package:education/ui/widgets/button.dart';
import 'package:education/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SelectRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey,
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Image.asset('assets/images/main.png'),
                SizedBox(
                  height: 100,
                ),
                BottomButton(
                  name: 'СОТРУДНИК',
                  handler: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(IsAdminAction(false));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(false),
                        ));
                  },
                ),
                BottomButton(
                  name: 'АДМИНИСТРАТОР',
                  handler: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(IsAdminAction(true));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(true),
                        ));
                  },
                ),
              ],
            ),
          );
        });
  }
}
