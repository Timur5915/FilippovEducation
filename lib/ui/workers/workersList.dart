import 'package:education/ui/groups/new_group.dart';
import 'package:education/ui/workers/new_worker.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:education/ui/workers/workerInfo.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class WorkerListScreen extends StatefulWidget {
  final Group group;
  WorkerListScreen({this.group});
  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class Group {
  final String name;
  final int id;
  Group({this.id, this.name});
}

class FAQ {
  final String id;
  final String answer;
  final String question;
  FAQ({this.answer, this.id, this.question});
}

class Worker {
  final String id;
  final String name;
  final String date;
  final String login;
  final String pwd;
  final String number;
  final String work;
  Worker(
      {this.date,
      this.name,
      this.number,
      this.work,
      this.id,
      this.login,
      this.pwd});
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var workers = new List<Worker>();
  String status = 'connection';
  void getData() {
    status = 'connection';
    databaseReference
        .child('groups/${widget.group.id}/workers')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          workers.add(new Worker(
            login: snapshot.value[i]['login'],
            pwd: snapshot.value[i]['pwd'],
            id: snapshot.value[i]['id'],
            name: snapshot.value[i]['name'],
            date: snapshot.value[i]['date'],
            number: snapshot.value[i]['number'],
            work: snapshot.value[i]['work'],
          ));
          setState(() {
            status = 'done';
            print('done');
            return;
          });
        }
      } else {
        setState(() {});
        status = 'empty';
        print('empty');
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
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        body: (status == 'done')
            ? ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => new WorkerInfoScreen(
                                          group: widget.group,
                                          worker: workers[index],
                                        ))),
                            child: ListTile(
                              title: Text(
                                toBeginningOfSentenceCase(workers[index].name),
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
            : (status == 'empty')
                ? Center(
                    child: Text(
                      'У вас пока нет ни одного сотрудника',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.red),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => NewWorkerScreen(
                            group: widget.group,
                          ))),
            )
          ],
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            '${toBeginningOfSentenceCase(widget.group.name)}',
          ),
        ),
      ),
    );
  }
}
