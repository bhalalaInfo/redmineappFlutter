import 'package:flutter/material.dart';
import 'package:redmineapp/screens/TimeEntry/TimeEntry.dart';
import 'package:redmineapp/screens/login/LoginPage.dart';
import 'package:redmineapp/screens/scanner.dart';

var routes = <String, WidgetBuilder>{
  '/Login': (BuildContext ctx) => new LoginPage(),
  "/home": (BuildContext ctx) => new TimeEntry(),
  "/scan": (BuildContext ctx)=> new Scanner(),
};
