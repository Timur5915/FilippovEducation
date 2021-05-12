import 'package:education/actions.dart';
import 'package:education/appstate.dart';
import 'package:education/data/news.dart';
import 'package:education/ui/news/add_news.dart';
import 'package:education/ui/news/detailsNews.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/listOfThemes.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final bool isAdmin;
  MainScreen({this.isAdmin});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var news = new List<News>();
  String status = 'connection';
  bool update = false;
  void getData() {
    print('updating');
    final databaseReference = FirebaseDatabase.instance.reference();
    news = [];
    status = 'connection';
    databaseReference.child('news').once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value != null) {
        for (int i = snapshot.value.length - 1; i >= 0; i--) {
          news.add(new News(
            id: snapshot.value[i]['id'].toString(),
            title: snapshot.value[i]['title'],
            timestamp: snapshot.value[i]['timestamp'],
            text: snapshot.value[i]['text'],
            image: snapshot.value[i]['image'],
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

  List<Themes> getThemes(List<dynamic> themes) {
    var th = List<Themes>();
    if (themes != null) {
      for (final theme in themes) {
        th.add(Themes(
            id: theme['id'],
            name: theme['name'],
            blocks: getBlocks(theme['blocks']),
            workerQuestion: getWorkersQuestion(theme['workersQuestion']),
            workersBlock: getWorkersBlock(theme['workersBlock']),
            questions: getQuestions(theme['questions'])));
      }
    } else {
      return th;
    }
    return th;
  }

  List<Block> getBlocks(List<dynamic> blocks) {
    var th = List<Block>();
    if (blocks != null) {
      for (final block in blocks) {
        th.add(Block(info: block['info'], type: block['type']));
      }
    }
    return th;
  }

  List<WorkersBlock> getWorkersBlock(List<dynamic> blocks) {
    var th = List<WorkersBlock>();
    if (blocks != null) {
      for (final block in blocks) {
        th.add(WorkersBlock(login: block['login']));
      }
    }
    return th;
  }

  List<WorkersQuestion> getWorkersQuestion(List<dynamic> blocks) {
    var th = List<WorkersQuestion>();
    if (blocks != null) {
      for (final block in blocks) {
        th.add(WorkersQuestion(
            login: block['login'],
            answers: getAnswers(block['answers']),
            grade: block['grade']));
      }
    }
    return th;
  }

  List<String> getAnswers(List<dynamic> blocks) {
    var th = List<String>();
    if (blocks != null) {
      for (final block in blocks) {
        th.add(block);
      }
    }
    return th;
  }

  List<Question> getQuestions(List<dynamic> questions) {
    var th = List<Question>();
    if (questions != null) {
      for (final question in questions) {
        th.add(Question(
            answerId: question['answerId'],
            question: question['question'],
            variants: question['variants']));
      }
    } else {
      return th;
    }
    return th;
  }

  void getModules() {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('modules').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        var modules = new List<Module>();
        for (int i = 0; i < snapshot.value.length; i++) {
          modules.add(
            new Module(
              id: int.parse(snapshot.value[i]['id']),
              name: snapshot.value[i]['name'],
              themes: getThemes(snapshot.value[i]['themes']),
            ),
          );
        }
        print(modules);
        StoreProvider.of<AppState>(context)
            .dispatch(SaveModulesAction(modules));
        return;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();

    update = true;
    getModules();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    // getData()
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Theme(
              data:
                  ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
              child: Theme(
                data: ThemeData(
                    primaryIconTheme: IconThemeData(color: Colors.red)),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  drawer: NavDrawer(),
                  appBar: AppBar(
                    backgroundColor: Colors.grey,
                    centerTitle: true,
                    title: Text(
                      'Новости',
                    ),
                  ),
                  body: (status == 'done')
                      ? ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (index == 0 && widget.isAdmin)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: InkWell(
                                          onTap: () async {
                                            update = false;
                                            var meow = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        new AddNewsScreen()));
                                            if (meow == false) {
                                              setState(() {
                                                status = 'connection';
                                              });
                                              getData();
                                            }
                                          },
                                          child: Icon(
                                            Icons.add_box_outlined,
                                            size: 40,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                if (index == 0 && !widget.isAdmin)
                                  Card(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.worker.name}, привествуем Вас!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        var meow = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    new NewsDetailsScreen(
                                                        news: news[index])));
                                        if (meow == false) getData();
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              news[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Image.memory(base64Decode(
                                                  news[index].image))),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            news[index].text,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            getTime(news[index].timestamp),
                                            maxLines: null,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          itemCount: news.length,
                        )
                      : status == 'empty'
                          ? Center(
                              child: InkWell(
                                  onTap: () async {
                                    update = false;
                                    var meow = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                new AddNewsScreen()));
                                    if (meow == false) getData();
                                  },
                                  child: Icon(Icons.add)),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ),
                            ),
                ),
              ));
        });
  }
}
