import 'package:education/actions.dart';
import 'package:education/appstate.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/new_module.dart';
import 'package:education/ui/themes/new_theme.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'chooseTeoryOrTest.dart';

class ThemeListScreen extends StatefulWidget {
  final Module module;
  final bool isAdmin;

  ThemeListScreen({this.module, this.isAdmin});
  @override
  _ThemeListScreenState createState() => _ThemeListScreenState();
}

class Themes {
  final String name;
  final int id;
  final List<Block> blocks;
  final List<Question> questions;
  final List<WorkersQuestion> workerQuestion;
  final List<WorkersBlock> workersBlock;
  Themes({
    this.id,
    this.workerQuestion,
    this.name,
    this.blocks,
    this.workersBlock,
    this.questions,
  });
}

class Block {
  final String type;
  final String info;

  Block({
    this.info,
    this.type,
  });
}

class Question {
  final String answerId;
  final String question;
  final String variants;
  Question({this.answerId, this.variants, this.question});
}

class WorkersQuestion {
  final String login;
  final int grade;
  final List<String> answers;
  WorkersQuestion({this.login, this.answers, this.grade});
}

class WorkersBlock {
  final String login;
  WorkersBlock({this.login});
}

class _ThemeListScreenState extends State<ThemeListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var themes = new List<Themes>();
  String status = 'connection';
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

  void getData() {
    status = 'connection';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        onInit: (store) {
          getData();
        },
        converter: (store) => store.state,
        builder: (context, state) {
          // StoreProvider.of<AppState>(context).dispatch(ThemesAction(themes));
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(),
              body: (status == 'done')
                  ? ListView.builder(
                      itemCount: themes.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: [
                                InkWell(
                                  child: ListTile(
                                    title: Text(
                                      '${toBeginningOfSentenceCase(themes[index].name)}',
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      new TheoryTestScreen(
                                                        module: widget.module,
                                                        isAdmin: widget.isAdmin,
                                                        theme: themes[index],
                                                      )));
                                        }),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                if (themes.length - 1 == index && state.isAdmin)
                                  Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.add,
                                          color: Colors.red,
                                        ),
                                        title: Text('Добавить тему'),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    new NewThemeScreen(
                                                      module: widget.module,
                                                    ))),
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ))
                  : (status == 'empty')
                      ? Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.add,
                                color: Colors.red,
                              ),
                              title: Text('Добавить тему'),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => new NewThemeScreen(
                                            module: widget.module,
                                          ))),
                            )
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
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
                  toBeginningOfSentenceCase('${widget.module.name}'),
                ),
              ),
            ),
          );
        });
  }
}
