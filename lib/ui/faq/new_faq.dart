import 'package:education/ui/faq/faq.dart';
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

class AddFAQScreen extends StatefulWidget {
  @override
  _AddFAQScreenState createState() => _AddFAQScreenState();
}

class _AddFAQScreenState extends State<AddFAQScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  int index = 0;
  var controllerAnswer = new TextEditingController();
  var controllerQuestion = new TextEditingController();

  String base64Image;
  void createRecord() {
    databaseReference.child("faq/$index").set({
      'id': index,
      'question': controllerQuestion.text,
      'answer': controllerAnswer.text,
    });
  }

  void getData() {
    databaseReference.child('faq').once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value != null) {
        index = int.parse(snapshot.value.last['id'].toString()) + 1;
      } else {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  final picker = ImagePicker();
  File _image;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    List<int> imageBytes = await _image.readAsBytes();
    base64Image = base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    print(base64Image);
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: controllerQuestion,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 16.0),
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        hintText: 'Введите вопрос',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.8,
                              style: BorderStyle.solid,
                              color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.8,
                              style: BorderStyle.solid,
                              color: Colors.grey[400]),
                        ),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: controllerAnswer,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        hintText: 'Введите ответ',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.8,
                              style: BorderStyle.solid,
                              color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.8,
                              style: BorderStyle.solid,
                              color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BottomButton(
                name: 'Добавить',
                handler: controllerQuestion.text != null &&
                        controllerAnswer.text != null
                    ? () {
                        createRecord();
                        Navigator.pop(context, false);
                      }
                    : null,
              )
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) => FAQListScreen())),
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
