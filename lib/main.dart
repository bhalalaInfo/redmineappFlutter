import 'package:flutter/material.dart';
import 'package:redmineapp/screens/SplashScreen.dart';
import 'package:redmineapp/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  loadConfigs();
  runApp(RedmineTEApp());
}

void loadConfigs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var baseUrl = prefs.get("BaseUrl");
  if (baseUrl == null)
    prefs.setString("BaseUrl", "http://127.0.0.1:81/redmine");
  else
    print(baseUrl);
}

class RedmineTEApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: new SplashScreen(), routes: routes);
  }
}
