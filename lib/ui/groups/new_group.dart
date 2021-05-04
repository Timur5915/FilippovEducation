import 'package:education/ui/widgets/button.dart';
import 'package:education/ui/groups/groupsList.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewGroupScreen extends StatefulWidget {
  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();

  var controller = new TextEditingController();
  int index = 0;
  void createRecord(String name, int index) {
    databaseReference
        .child("groups/$index")
        .set({'name': '$name', 'id': '$index'});
  }

  void getData() {
    databaseReference.child('groups').once().then((DataSnapshot snapshot) {
      snapshot.value != null
          ? index =
              int.parse(snapshot.value[snapshot.value.length - 1]['id']) + 1
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
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Название отдела',
                    style: const TextStyle(color: const Color(0xff939393)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: controller,
                    cursorColor: Colors.red,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                      hintText: 'Введите название...',
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
              handler: () {
                createRecord(controller.text, index);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => GroupsListScreen()));
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
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) => GroupsListScreen())),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Новый отдел',
          ),
        ),
      ),
    );
  }
}
