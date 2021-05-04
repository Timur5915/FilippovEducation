import 'package:education/appstate.dart';
import 'package:education/ui/faq/faq.dart';
import 'package:education/ui/groups/groupsList.dart';
import 'package:education/ui/selectRole.dart';
import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/login.dart';
import 'package:education/ui/main_screen.dart';
import 'package:education/ui/statistics.dart';
import 'package:education/ui/workers/personal_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          var isAdmin = state.isAdmin;
          return Drawer(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                if (!isAdmin)
                  Divider(
                    height: 8,
                    color: Colors.red,
                  ),
                if (!isAdmin)
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Профиль',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => PersonalInfoScreen(
                                  worker: state.worker,
                                ))),
                  ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/news.png',
                    color: Colors.red,
                    width: 25,
                  ),
                  title: Text(
                    'Новости',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => MainScreen(
                                isAdmin: isAdmin,
                              ))),
                ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/book.png',
                    color: Colors.red,
                    width: 25,
                  ),
                  title: Text(
                    'Темы',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ModuleListScreen(
                                isAdmin: isAdmin,
                              ))),
                ),
                if (isAdmin)
                  Divider(
                    height: 8,
                    color: Colors.red,
                  ),
                if (isAdmin)
                  ListTile(
                    leading: Icon(
                      Icons.people_alt_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Сотрудники',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => GroupsListScreen())),
                  ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Icon(
                    Icons.legend_toggle_sharp,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Статистика',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => StatisticsScreen())),
                ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '?',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                  title: Text(
                    'FAQ',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => FAQListScreen())),
                ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Выход',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SelectRoleScreen())),
                ),
                Divider(
                  height: 8,
                  color: Colors.red,
                ),
              ],
            ),
          );
        });
  }
}
