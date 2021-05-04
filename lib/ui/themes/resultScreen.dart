import 'package:education/ui/themes/chooseTeoryOrTest.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listOfThemes.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:education/appstate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class QuizResultScreen extends StatefulWidget {
  final Map<String, String> answers;
  final String grade;
  final Module module;
  final Themes theme;
  QuizResultScreen({this.answers, this.grade, this.theme, this.module});
  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/kubok.png',
                    color: Colors.grey,
                    scale: 2,
                  ),
                  Text(
                    'Ваш результат ${widget.grade}/${widget.answers.length} !',
                    style: TextStyle(fontSize: 16),
                  ),
                  BottomButton(
                    name: 'ГОТОВО',
                    handler: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => TheoryTestScreen(
                                  isAdmin: state.isAdmin,
                                  module: widget.module,
                                  theme: widget.theme,
                                ))),
                  )
                ],
              ),
            ));
      },
    );
  }
}
