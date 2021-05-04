import 'package:education/ui/widgets/button.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listOfThemes.dart';
import 'package:flutter/material.dart';

class NewThemeScreen extends StatefulWidget {
  final Module module;
  NewThemeScreen({this.module});
  @override
  _NewThemeScreenState createState() => _NewThemeScreenState();
}

class _NewThemeScreenState extends State<NewThemeScreen> {
  var controller = new TextEditingController();
  int index = 0;

  final databaseReference = FirebaseDatabase.instance.reference();
  void createRecord() {
    databaseReference
        .child("modules/${widget.module.id}/themes/$index")
        .set({'name': controller.text, 'id': index});
  }

  void getData() {
    databaseReference
        .child('modules/${widget.module.id}/themes')
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value != null
          ? index = snapshot.value[snapshot.value.length - 1]['id'] + 1
          : index = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 16,
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
                    'Название темы',
                    style: const TextStyle(color: const Color(0xff939393)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    cursorColor: Colors.red,
                    controller: controller,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                      //    hintText: 'Введите название...',
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
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            BottomButton(
              name: 'Добавить',
              handler: () {
                createRecord();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ThemeListScreen(
                              module: widget.module,
                            )));
              },
            )
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) => ThemeListScreen(
                          module: widget.module,
                        ))),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Тема',
          ),
        ),
      ),
    );
  }
}
