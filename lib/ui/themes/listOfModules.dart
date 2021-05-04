import 'package:education/ui/themes/listOfThemes.dart';
import 'package:education/ui/themes/new_module.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModuleListScreen extends StatefulWidget {
  final bool isAdmin;
  ModuleListScreen({this.isAdmin});
  @override
  _ModuleListScreenState createState() => _ModuleListScreenState();
}

class Module {
  final String name;
  final int id;
  final List<Themes> themes;
  Module({this.id, this.name, this.themes});
}

class _ModuleListScreenState extends State<ModuleListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var modules;
  String status = 'connection';
  void getData() {
    status = 'connection';
    setState(() {});
    databaseReference.child('modules').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        modules = new List<Module>();
        for (int i = 0; i < snapshot.value.length; i++) {
          modules.add(
            new Module(
              id: int.parse(snapshot.value[i]['id']),
              name: snapshot.value[i]['name'],
              themes: getThemes(snapshot.value[i]['themes']),
            ),
          );

          setState(() {
            status = 'done';
          });
        }
        return;
      }
      modules = new List<Module>();
      status = 'done';
      setState(() {});
    });
  }

  List<Themes> getThemes(List<dynamic> themes) {
    var th = List<Themes>();
    if (themes != null) {
      for (final theme in themes) {
        th.add(Themes(id: theme['id'], name: theme['name']));
      }
    } else {
      return th;
    }
    return th;
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(status);
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        body: (status == 'done')
            ? modules.length > 0
                ? ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            new ThemeListScreen(
                                              module: modules[index],
                                              isAdmin: widget.isAdmin,
                                            ))),
                                child: ListTile(
                                  title: Text(
                                    toBeginningOfSentenceCase(
                                        modules[index].name),
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
                      'У вас пока нет ни одного модуля',
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
            if (widget.isAdmin)
              IconButton(
                icon: Icon(Icons.add, color: Colors.red),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => NewModuleScreen(
                              isAdmin: widget.isAdmin,
                            ))),
              )
          ],
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Модули',
          ),
        ),
      ),
    );
  }
}
