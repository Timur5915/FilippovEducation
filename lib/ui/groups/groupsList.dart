import 'package:education/appstate.dart';
import 'package:education/ui/groups/new_group.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class GroupsListScreen extends StatefulWidget {
  @override
  _GroupsListScreenState createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var groups = new List<Group>();
  String status = 'connection';
  void getData() {
    status = 'connection';
    databaseReference.child('groups').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          groups.add(new Group(
              name: snapshot.value[i]['name'],
              id: int.parse(snapshot.value[i]['id'])));
          print(groups);
          setState(() {
            status = 'done';
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(
                  //   isAdmin: state.isAdmin,
                  ),
              body: (status == 'done')
                  ? groups.length > 0
                      ? ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  new WorkerListScreen(
                                                    group: groups[index],
                                                  ))),
                                      child: ListTile(
                                        title: Text(
                                          toBeginningOfSentenceCase(
                                              groups[index].name),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            onPressed: null),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              ))
                      : Center(
                          child: Text(
                            'У вас пока нет ни одного отдела',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.red),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => NewGroupScreen())),
                  )
                ],
                backgroundColor: Colors.grey,
                centerTitle: true,
                title: Text(
                  'Отделы',
                ),
              ),
            ),
          );
        });
  }
}
