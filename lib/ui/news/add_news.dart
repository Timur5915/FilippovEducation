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

class AddNewsScreen extends StatefulWidget {
  AddNewsScreen();
  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  int index = 0;
  var controller = new TextEditingController();
  var controllerTitle = new TextEditingController();

  String base64Image;
  void createRecord() {
    var id = DateTime.now()
        .toString()
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll('-', '')
        .replaceAll(':', '');
    print("news/$id");
    databaseReference.child("news/$index").set({
      'id': index,
      'timestamp': id,
      'text': controller.text,
      'image': base64Image,
      'title': controllerTitle.text
    });
  }

  void getData() {
    databaseReference.child('news').once().then((DataSnapshot snapshot) {
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
                      'Изображение',
                      style: const TextStyle(color: const Color(0xff939393)),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: getImage,
                    child: base64Image != null
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xff939393))),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Image.memory(
                              base64Decode(base64Image),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xff939393))),
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            height: 208,
                            child: Container(
                                width: double.infinity,
                                child: Icon(
                                  Icons.image_search,
                                  color: const Color(0xff939393),
                                  size: 50,
                                )),
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
                      'Заголовок',
                      style: const TextStyle(color: const Color(0xff939393)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: controllerTitle,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 16.0),
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        hintText: 'Введите заголовок',
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
                      'Текст новости',
                      style: const TextStyle(color: const Color(0xff939393)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: controller,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        hintText: 'Введите текст новости',
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
                handler: base64Image != null &&
                        controller.text != null &&
                        controllerTitle.text != null
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
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Новость',
          ),
        ),
      ),
    );
  }
}
