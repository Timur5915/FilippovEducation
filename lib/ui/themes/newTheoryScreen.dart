import 'package:education/ui/themes/chooseTeoryOrTest.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listOfThemes.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:education/appstate.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class NewTheoryScreen extends StatefulWidget {
  final Module module;
  final bool isAdmin;
  final Themes theme;
  NewTheoryScreen({this.module, this.theme, this.isAdmin});
  @override
  _NewTheoryScreenState createState() => _NewTheoryScreenState();
}

class _NewTheoryScreenState extends State<NewTheoryScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var themes = new List<Themes>();
  var controller = new TextEditingController();
  var info = new List<Block>();
  bool isText = false;
  ScrollController _controller;
  bool isImage = false;
  final picker = ImagePicker();
  File _image;
  int indexUser = 0;
  String status = 'connection';
  String base64Image;
  @override
  void initState() {
    // TODO: implement initState
    //
    _controller = ScrollController();

    super.initState();
  }

  bool isEmpty = true;
  void getData(String login) {
    status = 'connection';
    databaseReference
        .child('modules/${widget.module.id}/themes/${widget.theme.id}/blocks')
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
          info.add(
            new Block(
              info: snapshot.value[i]['info'],
              type: snapshot.value[i]['type'],
            ),
          );

          setState(() {
            status = 'done';
            print('done');
            return;
          });
        }
      }
    });
    databaseReference
        .child(
            'modules/${widget.module.id}/themes/${widget.theme.id}/workersBlock')
        .once()
        .then((DataSnapshot snapshot) {
      snapshot.value != null
          ? indexUser = snapshot.value.length
          : indexUser = 0;
      if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          if (snapshot.value[i]['login'] == login) {
            indexUser = null;
            return;
          }
        }
      }
    });
  }

  void watched(String id) {
    //print('haha$indexUser');
    if (indexUser == null) return;
    databaseReference
        .child(
            "modules/${widget.module.id}/themes/${widget.theme.id}/workersBlock/$indexUser")
        .set({'login': id});
  }

  void createRecord() {
    for (int i = 0; i < info.length; i++) {
      databaseReference
          .child(
              "modules/${widget.module.id}/themes/${widget.theme.id}/blocks/$i")
          .set({'type': info[i].type, 'info': info[i].info});
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    List<int> imageBytes = await _image.readAsBytes();
    base64Image = base64Encode(imageBytes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (info.length > 1 && isEmpty)
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(
          _controller.position.maxScrollExtent +
              MediaQuery.of(context).size.height,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

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
                          controller: _controller,
                          itemBuilder: (context, index) {
                            if (index == info.length)
                              return Column(
                                children: [
                                  if (!isText)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: InkWell(
                                        onTap: () {
                                          isText = true;
                                          isImage = false;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Добавить текст',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  if (isText)
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Текст',
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
                                            onChanged: (value) {},
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.0),
                                              hintText: 'Введите текст',
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
                                            width: 200,
                                            alignment: Alignment.centerRight,
                                            child: BottomButton(
                                              name: 'Добавить',
                                              handler: () {
                                                isText = false;
                                                setState(() {});
                                                info.add(Block(
                                                    type: 'text',
                                                    info: controller.text));
                                                controller.text = '';
                                              },
                                            )),
                                      ],
                                    ),
                                  if (!isImage)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: InkWell(
                                        onTap: () {
                                          isImage = true;
                                          isText = false;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Добавить изображение',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  if (isImage)
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: getImage,
                                          child: base64Image != null
                                              ? Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff939393))),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: Image.memory(
                                                    base64Decode(base64Image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff939393))),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  width: double.infinity,
                                                  height: 208,
                                                  child: Container(
                                                      width: double.infinity,
                                                      child: Icon(
                                                        Icons.image_search,
                                                        color: const Color(
                                                            0xff939393),
                                                        size: 50,
                                                      )),
                                                ),
                                        ),
                                        Container(
                                            width: 200,
                                            margin: EdgeInsets.only(top: 16),
                                            alignment: Alignment.centerRight,
                                            child: BottomButton(
                                              name: 'Добавить',
                                              handler: base64Image != null
                                                  ? () {
                                                      isImage = false;
                                                      setState(() {});
                                                      info.add(Block(
                                                          type: 'image',
                                                          info: base64Image));
                                                      base64Image = null;
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
                                          Navigator.pop(context);
                                        },
                                      )),
                                ],
                              );
                            else
                              return info[index].type == 'text'
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        info[index].info,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0xff939393))),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Image.memory(
                                        base64Decode(info[index].info),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                          },
                          itemCount: info.length + 1,
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == info.length) {
                              if (widget.isAdmin) return Container();
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: BottomButton(
                                    name: 'Готово',
                                    handler: () {
                                      watched(state.worker.login);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  TheoryTestScreen(
                                                    isAdmin: state.isAdmin,
                                                    module: widget.module,
                                                    theme: widget.theme,
                                                  )));
                                    }),
                              );
                            }

                            return info[index].type == 'text'
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      info[index].info,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: const Color(0xff939393))),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Image.memory(
                                      base64Decode(info[index].info),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                          },
                          itemCount: info.length + 1,
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
                title: Text('Теория'),
              ),
            ),
          );
        });
  }
}
