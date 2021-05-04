import 'package:education/ui/widgets/button.dart';

import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class FAQDetailsScreen extends StatefulWidget {
  final FAQ faq;
  FAQDetailsScreen(this.faq);
  @override
  _FAQDetailsScreenState createState() => _FAQDetailsScreenState();
}

class _FAQDetailsScreenState extends State<FAQDetailsScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  int index = 0;
  var controllerAnswer = new TextEditingController();
  var controllerQuestion = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Вопрос',
                      style: const TextStyle(color: const Color(0xff939393)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.faq.question,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ответ',
                      style: const TextStyle(color: const Color(0xff939393)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.faq.answer,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Ответ',
          ),
        ),
      ),
    );
  }
}
