import 'package:education/ui/widgets/button.dart';

import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:education/ui/main_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:education/data/news.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class NewsDetailsScreen extends StatefulWidget {
  final News news;
  
  NewsDetailsScreen({this.news});
  @override
  _NewsDetailsScreenState createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  int index = 0;
  var controller = new TextEditingController();
  var controllerTitle = new TextEditingController();

  String base64Image;
  String getTime(String str) {
    var year = str.substring(0, 4);
    var month = str.substring(4, 6);
    var day = str.substring(6, 8);
    var hour = str.substring(8, 10);
    var min = str.substring(10, 12);
    print(str);
    return '$hour:$min $day.$month.$year';
  }

  @override
  void initState() {
    // TODO: implement initState

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
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xff939393))),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Image.memory(
                    base64Decode(widget.news.image),
                    fit: BoxFit.cover,
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
                    widget.news.text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getTime(widget.news.timestamp),
                    style: const TextStyle(
                        color: const Color(0xff939393), fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
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
            widget.news.title,
          ),
        ),
      ),
    );
  }
}
