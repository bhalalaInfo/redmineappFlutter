import 'package:flutter/material.dart';

// import 'package:redmineapp/Screens/login/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  BuildContext _ctx;
  final baseUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseUrlController.text = prefs.get("BaseUrl");
    });
    print("From Setting screen ${baseUrlController.text}");
  }

  Stack buildContent(BuildContext context) {
    _ctx = context;
    return new Stack(fit: StackFit.expand, children: <Widget>[
      new Image(
        image: new AssetImage("assets/Logo.png"),
        fit: BoxFit.cover,
        color: Colors.black87,
        colorBlendMode: BlendMode.darken,
      ),
      Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.teal,
              inputDecorationTheme: new InputDecorationTheme(
                  labelStyle:
                      new TextStyle(color: Colors.teal, fontSize: 25.0))),
          child: Column(
            children: <Widget>[
              Text("Base Url", style: TextStyle(color: Colors.teal)),
              TextField(
                  controller: baseUrlController,
                  decoration: InputDecoration(hintText: "Base Url")),
              MaterialButton(
                child: Text("Save"),
                onPressed: _saveSettings,
              )
            ],
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text("Settings")),
      body: buildContent(context),
    );
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = await prefs.setString("BaseUrl", baseUrlController.text);
    // Navigator.of(_ctx).pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    if (isSaved)
      Toast.show("Settings Saved !!!", _ctx,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    else
      Toast.show("Settings not Saved !!!", _ctx,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
