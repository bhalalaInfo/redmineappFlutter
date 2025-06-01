import 'package:flutter/material.dart';
import 'package:redmineapp/screens/Setting/Settings.dart';
import 'package:redmineapp/auth/auth.dart';
import 'package:redmineapp/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'login_screen_presenter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin
    implements LoginScreenContract, AuthStateListener {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  late BuildContext _ctx;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  late String _userName;
  late String _password;
  late LoginScreenPresenter _presenter;
  bool _isLoading = false;
  bool _obscureText = true;

  _LoginPageState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    _userName = "";
    _password = "";
  }

  void _emailSupport() async {
    const url =
        "mailto:bhalalapj@gmail.com?subject=Hey, i have issue on Redmine App &body=Help Me on following issue. ";
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
    Toast.show("Email support",
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  void _loginPressed() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() => _isLoading = true);
      _presenter.doLogin(_userName, _password);
    }
  }

  void _gotoSetting() {
    Navigator.of(_ctx)
        .push(MaterialPageRoute(builder: (BuildContext context) => Setting()));
  }

  @override
  onAuthStateChanged(AuthState state) async {
    if (state == AuthState.LOGGED_IN) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("Creds", "$_userName:$_password");
      Navigator.of(_ctx).pushReplacementNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
        key: scaffoldKey,
        body: buildContent(),
        floatingActionButton: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.teal[300],
              onPressed: _gotoSetting,
              tooltip: 'Settings',
              child: Icon(Icons.settings),
              mini: true,
              heroTag: null,
            ),
            FloatingActionButton(
              backgroundColor: Colors.teal[300],
              onPressed: _emailSupport,
              tooltip: 'help',
              child: Icon(Icons.help),
              mini: true,
            ),
          ],
        ));
  }

  Stack buildContent() {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Image(
          image: new AssetImage("assets/Logo.png"),
          fit: BoxFit.cover,
          color: Colors.black87,
          colorBlendMode: BlendMode.darken,
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlutterLogo(
              size: _iconAnimation.value * 100,
            ),
            new Form(
                key: _formKey,
                child: Theme(
                  data: new ThemeData(
                      brightness: Brightness.dark,
                      primaryColor: Colors.teal,
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                              color: Colors.teal, fontSize: 25.0))),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: InputDecoration(
                            labelText: "Username",
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) => value!.trim().isEmpty
                              ? 'Username can\'t empty'
                              : null,
                          onSaved: (value) => _userName = value!.trim(),
                        ),
                        new TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: IconButton(
                                onPressed: (() {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                          keyboardType: TextInputType.text,
                          validator: (value) => value!.trim().isEmpty
                              ? 'password can\'t empty'
                              : null,
                          onSaved: (value) => _password = value!.trim(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        _isLoading
                            ? new CircularProgressIndicator()
                            : new MaterialButton(
                                height: 40.0,
                                minWidth: 100.0,
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text(
                                  "Login",
                                  style: new TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                onPressed: _loginPressed,
                                splashColor: Colors.redAccent,
                              )
                      ],
                    ),
                  ),
                ))
          ],
        )
      ],
    );
  }

  @override
  void onLoginError(String errorTxt) {
    setState(() => _isLoading = false);
    Toast.show(errorTxt, duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  @override
  void onLoginSuccess(UserInfo user) async {
    setState(() => _isLoading = false);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
