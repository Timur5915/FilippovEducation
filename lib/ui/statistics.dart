import 'package:education/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryIconTheme: IconThemeData(color: Colors.red)),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        body: Center(
          child: Text(
            'Добавьте сотрудников для отображения статистики',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text(
            'Статистика',
          ),
        ),
      ),
    );
  }
}
