import 'package:education/actions.dart';
import 'package:education/appstate.dart';
import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'faq_details.dart';
import 'new_faq.dart';

class FAQListScreen extends StatefulWidget {
  @override
  _FAQListScreenState createState() => _FAQListScreenState();
}

class _FAQListScreenState extends State<FAQListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var faq = new List<FAQ>();
  String status = 'connection';
  void getData() {
    status = 'connection';
    databaseReference.child('faq').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (int i = 0; i < snapshot.value.length; i++) {
          faq.add(new FAQ(
              answer: snapshot.value[i]['answer'],
              question: snapshot.value[i]['question'],
              id: snapshot.value[i]['id'].toString()));
          print(faq);
          setState(() {
            status = 'done';
          });
        }
        StoreProvider.of<AppState>(context).dispatch(FAQActions(faq));
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Theme(
            data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: NavDrawer(
                  //  isAdmin: state.isAdmin,
                  ),
              body: (status == 'done')
                  ? state.faq.length == 0
                      ? Center(
                          child: Text(
                            'У вас пока нет ни одного вопроса',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 16, bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FAQDetailsScreen(faq[index])));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${index + 1}. ${faq[index].question}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                      onPressed: null),
                                ],
                              ),
                            ),
                          ),
                          itemCount: faq.length,
                        )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
              appBar: AppBar(
                actions: [
                  if (state.isAdmin)
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.red),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddFAQScreen()));
                      },
                    )
                ],
                backgroundColor: Colors.grey,
                centerTitle: true,
                title: Text(
                  'FAQ',
                ),
              ),
            ),
          );
        });
  }
}
