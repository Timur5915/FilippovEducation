import 'package:education/ui/widgets/button.dart';

import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerInfoScreen extends StatefulWidget {
  final Worker worker;
  final Group group;

  WorkerInfoScreen({this.worker, this.group});
  @override
  _WorkerInfoScreenState createState() => _WorkerInfoScreenState();
}

class _WorkerInfoScreenState extends State<WorkerInfoScreen> {
  var controllerWork = new TextEditingController();
  var controllerName = new TextEditingController();
  var controllerDate = new TextEditingController();
  var controllerNumber = new TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();

  var controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

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
                  name: widget.worker.work,
                  label: 'Должность',
                  controller: controllerWork,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: widget.worker.name,
                  label: 'ФИО',
                  controller: controllerName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: widget.worker.date,
                  label: 'Дата',
                  controller: controllerDate,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldInput(
                  name: widget.worker.number,
                  label: 'Номер телефона',
                  controller: controllerNumber,
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
            'Сотрудник',
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
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
