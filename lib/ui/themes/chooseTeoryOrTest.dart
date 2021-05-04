import 'package:education/actions.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/newQuestionScreen.dart';
import 'package:education/ui/themes/newTheoryScreen.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:education/appstate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'listOfThemes.dart';

class TheoryTestScreen extends StatefulWidget {
  final Module module;
  final Themes theme;
  final bool isAdmin;
  TheoryTestScreen({this.module, this.theme, this.isAdmin});
  @override
  _TheoryTestScreenState createState() => _TheoryTestScreenState();
}

class Quest {
  final String answerId;
  final List<String> variants;
  Quest({this.answerId, this.variants});
}

class _TheoryTestScreenState extends State<TheoryTestScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var themes = new List<Themes>();
  bool isTheoryChecked = false;
  bool isQuizChecked = false;
  List<Block> getBlocks(List<dynamic> blocks) {
    var th = List<Block>();
    if (blocks != null) {
      for (final block in blocks) {
        th.add(Block(info: block['info'], type: block['block']));
      }
    } else {
      return th;
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

  void getDataThemes() {
    // status = 'connection';
    databaseReference
        .child('modules/${widget.module.id}/themes')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          themes.add(
            new Themes(
              id: snapshot.value[i]['id'],
              name: snapshot.value[i]['name'],
              blocks: getBlocks(snapshot.value[i]['blocks']),
              questions: getQuestions(snapshot.value[i]['questions']),
            ),
          );

          setState(() {
            //    status = 'done';
            print('done');
            return;
          });
        }
      } else {
        setState(() {});
        //  status = 'empty';
        print('empty');
      }
    });
  }

  void getData(String login) {
    databaseReference
        .child(
            'modules/${widget.module.id}/themes/${widget.theme.id}/workersBlock')
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value != null) {
        for (int j = 0; j < snapshot.value.length; j++) {
          if (snapshot.value[j]['login'] == login) {
            isTheoryChecked = true;
            setState(() {});
          }
        }
      }
    });
    databaseReference
        .child(
            'modules/${widget.module.id}/themes/${widget.theme.id}/workersQuestion')
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value != null) {
        for (int j = 0; j < snapshot.value.length; j++) {
          if (snapshot.value[j]['login'] == login) {
            isQuizChecked = true;
            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          getDataThemes();
          StoreProvider.of<AppState>(context).dispatch(ThemesAction(themes));
          store.state.isAdmin ? getData('') : getData(store.state.worker.login);
        },
        builder: (context, state) {
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(),
              body: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => new NewTheoryScreen(
                                    isAdmin: widget.isAdmin,
                                    module: widget.module,
                                    theme: widget.theme,
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        'Теория',
                      ),
                      trailing: IconButton(
                          icon: state.isAdmin
                              ? Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.red,
                                  size: 16,
                                )
                              : Icon(
                                  isTheoryChecked
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank,
                                  color: isTheoryChecked
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                          onPressed: null),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => new NewQuestionScreen(
                                    module: widget.module,
                                    theme: widget.theme,
                                    isAdmin: widget.isAdmin,
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        'Тест',
                      ),
                      trailing: IconButton(
                          icon: state.isAdmin
                              ? Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.red,
                                  size: 16,
                                )
                              : Icon(
                                  isQuizChecked
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank,
                                  color:
                                      isQuizChecked ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                          onPressed: null),
                    ),
                  ),
                  Divider(
                    thickness: 2,
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
                  toBeginningOfSentenceCase('${widget.theme.name}'),
                ),
              ),
            ),
          );
        });
  }
}
