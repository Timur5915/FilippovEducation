import 'package:education/ui/widgets/button.dart';

import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewWorkerScreen extends StatefulWidget {
  final Group group;
  NewWorkerScreen({this.group});
  @override
  _NewWorkerScreenState createState() => _NewWorkerScreenState();
}

class _NewWorkerScreenState extends State<NewWorkerScreen> {
  var controllerWork = new TextEditingController();
  var controllerName = new TextEditingController();
  var controllerDate = new TextEditingController();
  var controllerNumber = new TextEditingController();
  var controllerLogin = new TextEditingController();
  var controllerPwd = new TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();

  var controller = new TextEditingController();
  int index = 0;
  void createRecord() {
    databaseReference.child("groups/${widget.group.id}/workers/$index").set({
      'work': controllerWork.text,
      'name': controllerName.text,
      'date': controllerDate.text,
      'number': controllerNumber.text,
      'login': controllerLogin.text,
      'pwd': controllerPwd.text,
      'id': index.toString(),
    });
  }

  void getData() {
    databaseReference
        .child('groups/${widget.group.id}/workers')
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value != null
          ? index = int.parse(snapshot.value.last['id']) + 1
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
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите название должности...',
                  label: 'Должность',
                  controller: controllerWork,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите ФИО...',
                  label: 'ФИО',
                  controller: controllerName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите дату...',
                  label: 'Дата',
                  controller: controllerDate,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите номер телефона...',
                  label: 'Номер телефона',
                  controller: controllerNumber,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите логин...',
                  label: 'Логин',
                  controller: controllerLogin,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: 'Введите пароль...',
                  label: 'Пароль',
                  controller: controllerPwd,
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            BottomButton(
              name: 'Добавить',
              handler: () {
                createRecord();
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => WorkerListScreen(
                              group: widget.group,
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
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Новый сотрудник',
          ),
        ),
      ),
    );
  }
}

class TextFieldInput extends StatelessWidget {
  final String name;
  final String label;
  final TextEditingController controller;
  TextFieldInput({this.controller, this.label, this.name});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(color: const Color(0xff939393)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            controller: controller,
            cursorColor: Colors.red,
            style: const TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
              hintText: name,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 0.8, style: BorderStyle.solid, color: Colors.red),
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
    );
  }
}
