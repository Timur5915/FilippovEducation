import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/listOfThemes.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';

class WorkerAction {
  final Worker worker;
  WorkerAction(this.worker);
}

class IsAdminAction {
  final bool isAdmin;
  IsAdminAction(this.isAdmin);
}

class ThemesAction {
  final List<Themes> themes;
  ThemesAction(this.themes);
}

class FAQActions {
  final List<FAQ> faq;
  FAQActions(this.faq);
}

class SaveModulesAction {
  final List<Module> modules;
  SaveModulesAction(this.modules);
}
