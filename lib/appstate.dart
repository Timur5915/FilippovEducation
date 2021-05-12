import 'package:education/ui/themes/listOfModules.dart';
import 'package:education/ui/themes/listOfThemes.dart';
import 'package:education/ui/workers/workersList.dart';
import 'package:flutter/material.dart';

class AppState {
  Worker worker;
  bool isAdmin;
  List<Themes> themes;
  List<Module> modules;
  List<FAQ> faq;
  AppState({
    this.isAdmin,
    this.worker,
    this.modules,
    this.faq,
    this.themes,
  });

  AppState.fromAppState(AppState another) {
    worker = another.worker;
    isAdmin = another.isAdmin;
    themes = another.themes;
    faq = another.faq;
    modules = another.modules;
  }
}
