import 'package:education/actions.dart';
import 'package:education/appstate.dart';

AppState reducer(AppState prevState, dynamic action) {
  AppState newState = AppState.fromAppState(prevState);

  if (action is WorkerAction) {
    newState.worker = action.worker;
  }

  if (action is IsAdminAction) {
    newState.isAdmin = action.isAdmin;
  }

  if (action is ThemesAction) {
    newState.themes = action.themes;
  }

  if (action is FAQActions) {
    newState.faq = action.faq;
  }

  if (action is SaveModulesAction) {
    newState.modules = action.modules;
  }

  return newState;
}
