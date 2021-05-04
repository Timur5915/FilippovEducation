import 'package:education/appstate.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PersonalInfoScreen extends StatefulWidget {
  final Worker worker;
  PersonalInfoScreen({this.worker});
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Профиль'),
                centerTitle: true,
                backgroundColor: Colors.grey,
              ),
              backgroundColor: Colors.white,
              drawer: NavDrawer(),
              body: ListView(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldInput(
                    name: widget.worker.work,
                    label: 'Должность',
                    //  controller: controllerWork,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldInput(
                    name: widget.worker.name,
                    label: 'ФИО',
                    // controller: controllerName,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldInput(
                    name: widget.worker.date,
                    label: 'Дата',
                    // controller: controllerDate,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldInput(
                    name: widget.worker.number,

                    label: 'Номер телефона',
                    // controller: controllerNumber,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TextFieldInput extends StatelessWidget {
  final String name;
  final String label;

  TextFieldInput({this.label, this.name});
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
