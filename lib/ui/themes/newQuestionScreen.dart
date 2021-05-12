import 'package:education/ui/themes/chooseTeoryOrTest.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/resultScreen.dart';
import 'package:education/ui/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listOfThemes.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:education/appstate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class NewQuestionScreen extends StatefulWidget {
  final Module module;
  final Themes theme;
  final bool isAdmin;
  NewQuestionScreen({this.module, this.theme, this.isAdmin});
  @override
  _NewQuestionScreenState createState() => _NewQuestionScreenState();
}

class _NewQuestionScreenState extends State<NewQuestionScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var themes = new List<Themes>();
  var controller = new TextEditingController();
  var controller1 = new TextEditingController();
  var controller2 = new TextEditingController();
  var controller3 = new TextEditingController();
  var controller4 = new TextEditingController();
  var questions = new List<Question>();
  bool isQuestion = false;
  bool is1 = false;
  bool is2 = false;
  bool is3 = false;
  bool is4 = false;
  bool isImage = false;
  final picker = ImagePicker();
  File _image;
  String status = 'connection';
  String base64Image;
  int indexUser = 0;
  Map<String, String> answers = {};
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool isEmpty = true;
  void getData(String login) {
    status = 'connection';
    databaseReference
        .child(
            'modules/${widget.module.id}/themes/${widget.theme.id}/questions')
        .once()
        .then((DataSnapshot snapshot) {
      isEmpty = snapshot.value == null;
      if (isEmpty) {
        setState(() {
          status = 'done';
          print('done');
        });
        return;
      } else {
        for (int i = 0; i < snapshot.value.length; i++) {
          questions.add(
            new Question(
                answerId: snapshot.value[i]['id'],
                question: snapshot.value[i]['question'],
                variants: snapshot.value[i]['variants']),
          );
          answers['$i'] = '';
          setState(() {
            status = 'done';
            print('done');
            // return;
          });
        }
        print(answers);
      }
    });
    databaseReference
        .child(
            'modules/${widget.module.id}/themes/${widget.theme.id}/workersQuestion')
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value != null
          ? indexUser = snapshot.value.length
          : indexUser = 0;
      /* if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          if (snapshot.value[i]['login'] == login) {
            indexUser = null;
            return;
          }
        }
      }*/
    });
  }

  void watched(String id) {
    // if (indexUser == null) return;
    databaseReference
        .child(
            "modules/${widget.module.id}/themes/${widget.theme.id}/workersQuestion/$indexUser")
        .set({
      'login': id,
      'answers': answers,
      'grade': getGrade(),
      'timestamp': DateTime.now().toString()
    });
  }

  int getGrade() {
    var grade = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].answerId == answers['$i']) grade += 1;
    }
    return grade;
  }

  void createRecord() {
    for (int i = 0; i < questions.length; i++) {
      databaseReference
          .child(
              "modules/${widget.module.id}/themes/${widget.theme.id}/questions/$i")
          .set({
        'id': questions[i].answerId,
        'question': questions[i].question,
        'variants': questions[i].variants
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    List<int> imageBytes = await _image.readAsBytes();
    base64Image = base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          store.state.isAdmin ? getData('') : getData(store.state.worker.login);
        },
        builder: (context, state) {
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(),
              body: status == 'connection'
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : isEmpty
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            if (index != questions.length)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Вопрос',
                                      style: const TextStyle(
                                          color: const Color(0xff939393)),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(questions[index].question)),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Варианты',
                                      style: const TextStyle(
                                          color: const Color(0xff939393)),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: int.parse(
                                                  questions[index].answerId) ==
                                              1,
                                          focusColor: Colors.red,
                                          activeColor: Colors.red,
                                          onChanged: (v) {}),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(questions[index]
                                              .variants
                                              .split(';')[0]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: int.parse(
                                                  questions[index].answerId) ==
                                              2,
                                          focusColor: Colors.red,
                                          activeColor: Colors.red,
                                          onChanged: (v) {}),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(questions[index]
                                                .variants
                                                .split(';')[1])),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: int.parse(
                                                  questions[index].answerId) ==
                                              3,
                                          focusColor: Colors.red,
                                          activeColor: Colors.red,
                                          onChanged: (v) {}),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(questions[index]
                                                .variants
                                                .split(';')[2])),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: int.parse(
                                                  questions[index].answerId) ==
                                              4,
                                          focusColor: Colors.red,
                                          activeColor: Colors.red,
                                          onChanged: (v) {}),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(questions[index]
                                                .variants
                                                .split(';')[3])),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            if (index == questions.length)
                              return Column(
                                children: [
                                  if (!isQuestion)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: InkWell(
                                        onTap: () {
                                          isQuestion = true;

                                          setState(() {});
                                        },
                                        child: Text(
                                          'Добавить вопрос',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  if (isQuestion)
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Вопрос',
                                            style: const TextStyle(
                                                color: const Color(0xff939393)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            controller: controller,
                                            cursorColor: Colors.red,
                                            onChanged: (value) {
                                              //  setState(() {});
                                            },
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.0),
                                              hintText: 'Введите вопрос',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.auto,
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.8,
                                                    style: BorderStyle.solid,
                                                    color: Colors.red),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.8,
                                                    style: BorderStyle.solid,
                                                    color: Colors.grey[400]),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Варианты',
                                            style: const TextStyle(
                                                color: const Color(0xff939393)),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: is1,
                                                focusColor: Colors.red,
                                                activeColor: Colors.red,
                                                onChanged: (v) {
                                                  is1 = v;
                                                  is2 = is3 = is4 = !v;
                                                  setState(() {});
                                                }),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  controller: controller1,
                                                  cursorColor: Colors.red,
                                                  onChanged: (value) {
                                                    //  setState(() {});
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0),
                                                    hintText: 'Введите вариант',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color: Colors.red),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color:
                                                              Colors.grey[400]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                                focusColor: Colors.red,
                                                activeColor: Colors.red,
                                                value: is2,
                                                onChanged: (v) {
                                                  is2 = v;
                                                  is1 = is3 = is4 = !v;
                                                  setState(() {});
                                                }),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  controller: controller2,
                                                  cursorColor: Colors.red,
                                                  onChanged: (value) {
                                                    //  setState(() {});
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0),
                                                    hintText: 'Введите вариант',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color: Colors.red),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color:
                                                              Colors.grey[400]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                                focusColor: Colors.red,
                                                activeColor: Colors.red,
                                                value: is3,
                                                onChanged: (v) {
                                                  is3 = v;
                                                  is2 = is1 = is4 = !v;
                                                  setState(() {});
                                                }),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  controller: controller3,
                                                  cursorColor: Colors.red,
                                                  onChanged: (value) {
                                                    //  setState(() {});
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0),
                                                    hintText: 'Введите вариант',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color: Colors.red),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color:
                                                              Colors.grey[400]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                                focusColor: Colors.red,
                                                activeColor: Colors.red,
                                                value: is4,
                                                onChanged: (v) {
                                                  is4 = v;
                                                  is2 = is3 = is1 = !v;
                                                  setState(() {});
                                                }),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  controller: controller4,
                                                  cursorColor: Colors.red,
                                                  onChanged: (value) {
                                                    //  setState(() {});
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0),
                                                    hintText: 'Введите вариант',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color: Colors.red),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.8,
                                                          style:
                                                              BorderStyle.solid,
                                                          color:
                                                              Colors.grey[400]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            width: 200,
                                            alignment: Alignment.centerRight,
                                            child: BottomButton(
                                              name: 'Добавить',
                                              handler:
                                                  controller.text.isNotEmpty &&
                                                          controller1.text
                                                              .isNotEmpty &&
                                                          controller2.text
                                                              .isNotEmpty &&
                                                          controller3.text
                                                              .isNotEmpty &&
                                                          controller4.text
                                                              .isNotEmpty &&
                                                          (is1 ||
                                                              is2 ||
                                                              is3 ||
                                                              is4)
                                                      ? () {
                                                          // is1 = is2 = is3 = is4 = false;
                                                          isQuestion = false;
                                                          setState(() {});
                                                          questions.add(
                                                              Question(
                                                                  answerId: is1
                                                                      ? '1'
                                                                      : is2
                                                                          ? '2'
                                                                          : is3
                                                                              ? '3'
                                                                              : '4',
                                                                  question:
                                                                      controller
                                                                          .text,
                                                                  variants: controller1.text.toString() +
                                                                      ';' +
                                                                      controller2
                                                                          .text
                                                                          .toString() +
                                                                      ';' +
                                                                      controller3
                                                                          .text
                                                                          .toString() +
                                                                      ';' +
                                                                      controller4
                                                                          .text
                                                                          .toString()));
                                                          controller
                                                              .text = controller1
                                                                  .text =
                                                              controller2
                                                                  .text = controller3
                                                                      .text =
                                                                  controller4
                                                                      .text = '';
                                                          is1 = is2 =
                                                              is3 = is4 = false;
                                                        }
                                                      : null,
                                            )),
                                      ],
                                    ),
                                  Container(
                                      margin: EdgeInsets.only(top: 16),
                                      alignment: Alignment.centerRight,
                                      child: BottomButton(
                                        name: 'Сохранить',
                                        handler: () {
                                          createRecord();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      TheoryTestScreen(
                                                        isAdmin: state.isAdmin,
                                                        module: widget.module,
                                                        theme: widget.theme,
                                                      )));
                                        },
                                      )),
                                ],
                              );
                          },
                          itemCount: questions.length + 1,
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == questions.length) {
                              if (!state.isAdmin) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: BottomButton(
                                    name: 'Проверить',
                                    handler: () {
                                      watched(state.worker.login);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QuizResultScreen(
                                              module: widget.module,
                                              theme: widget.theme,
                                              answers: answers,
                                              grade: getGrade().toString(),
                                            ),
                                          ));
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Вопрос',
                                    style: const TextStyle(
                                        color: const Color(0xff939393)),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(questions[index].question)),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Варианты',
                                    style: const TextStyle(
                                        color: const Color(0xff939393)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: state.isAdmin
                                            ? int.parse(questions[index]
                                                    .answerId) ==
                                                1
                                            : answers['$index'] == '1',
                                        focusColor: Colors.red,
                                        activeColor: Colors.red,
                                        onChanged: (v) {
                                          answers['$index'] = '1';
                                          setState(() {});
                                        }),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(questions[index]
                                            .variants
                                            .split(';')[0]),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: state.isAdmin
                                            ? int.parse(questions[index]
                                                    .answerId) ==
                                                2
                                            : answers['$index'] == '2',
                                        focusColor: Colors.red,
                                        activeColor: Colors.red,
                                        onChanged: (v) {
                                          answers['$index'] = '2';
                                          setState(() {});
                                        }),
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(questions[index]
                                              .variants
                                              .split(';')[1])),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: state.isAdmin
                                            ? int.parse(questions[index]
                                                    .answerId) ==
                                                3
                                            : answers['$index'] == '3',
                                        focusColor: Colors.red,
                                        activeColor: Colors.red,
                                        onChanged: (v) {
                                          answers['$index'] = '3';
                                          setState(() {});
                                        }),
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(questions[index]
                                              .variants
                                              .split(';')[2])),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: state.isAdmin
                                            ? int.parse(questions[index]
                                                    .answerId) ==
                                                4
                                            : answers['$index'] == '4',
                                        focusColor: Colors.red,
                                        activeColor: Colors.red,
                                        onChanged: (v) {
                                          answers['$index'] = '4';
                                          setState(() {});
                                        }),
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(questions[index]
                                              .variants
                                              .split(';')[3])),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          itemCount: questions.length + 1,
                        ),
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => TheoryTestScreen(
                            isAdmin: state.isAdmin,
                            module: widget.module,
                            theme: widget.theme,
                          ),
                        ))),
                backgroundColor: Colors.grey,
                centerTitle: true,
                title: Text('Теория'),
              ),
            ),
          );
        });
  }
}
