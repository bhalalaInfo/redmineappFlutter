import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:qr_reader/qr_reader.dart';
import 'package:redmineapp/screens/TimeEntry/time_entry_screen_presenter.dart';
import 'package:redmineapp/screens/scanner.dart';
import 'package:redmineapp/models/ActivityModel.dart';
import 'package:redmineapp/models/issueModel.dart';
import 'package:redmineapp/models/projectModel.dart';
import 'package:toast/toast.dart';

class TimeEntry extends StatefulWidget {
  @override
  _TimeEntryState createState() => _TimeEntryState();
}

class _TimeEntryState extends State<TimeEntry>
    with SingleTickerProviderStateMixin
    implements TimeEntryScreenContract {
  final _formKey = new GlobalKey<FormState>();

  Project _selectedProject;
  Issue _selectedIssue;
  DateTime _selectedDate;
  Activity _selectedActivity;
  String _description;
  String _displayDate;
  String _hours;
  TimeEntryScreenPresenter _presenter;
  BuildContext _ctx;
  int minLength = 18;

  List<Project> _projects;
  List<Issue> _issues;
  List<Activity> _activites;

  _TimeEntryState() {
    _presenter = new TimeEntryScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _selectedProject = null;
    _selectedIssue = null;
    _selectedDate = DateTime.now();
    _displayDate = 'Select Date';
    _selectedActivity = null;
    loadMasterData();
  }

  void goToScanner() async {
    // Navigator.of(_ctx)
    //     .push(MaterialPageRoute(builder: (BuildContext context) => Scanner()));
    String data = await QRCodeReader().scan();
    var obj = json.decode(data);
    setState(() {
      if (obj["project"] != null)
        _selectedProject =
            _projects.where((p) => p.name == obj["project"]).toList().first;

      if (obj["issue"] != null)
        _selectedIssue = _issues
            .where((i) => i.subject.contains(obj["issue"]))
            .toList()
            .first;

      if (obj["description"] != null)
        _description = obj["description"].toString();

      if (obj["hours"] != null) _hours = obj["hours"].toString();
    });
  }

  void _handleDateSelection() {
    DatePicker.showDatePicker(_ctx,
        showTitleActions: true,
        minTime: DateTime(2014, 1, 1),
        maxTime: DateTime.now(), onConfirm: (date) {
      setState(() {
        _selectedDate = date;
        _displayDate = '${date.year}-${date.month}-${date.day}';
      });
    });
  }

  void loadMasterData() {
    _projects = new List<Project>();
    _issues = new List<Issue>();
    _activites = new List<Activity>();
    _presenter.getProjects();
    _presenter.getActivities();
    // _presenter.getIssues();
    // _presenter.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    // double maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: new Text("Time Entry"),
        actions: <Widget>[
          new MaterialButton(
            onPressed: goToScanner,
            child: Icon(Icons.photo_camera),
            splashColor: Colors.redAccent,
          )
        ],
      ),
      body: buildScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: (() => {}),
        tooltip: 'Help',
        child: Icon(Icons.email),
      ),
    );
  }

  Stack buildScreen() {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Form(
              key: _formKey,
              child: Theme(
                data: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: Colors.teal,
                    inputDecorationTheme: new InputDecorationTheme(
                        labelStyle:
                            new TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<Project>(
                        isExpanded: true,
                        value: _selectedProject,
                        hint: new Text("Select Project"),
                        style: TextStyle(color: Colors.white),
                        underline: Container(
                          height: 2,
                          color: Colors.tealAccent,
                        ),
                        onChanged: (Project newValue) {
                          _issues.clear();
                          setState(() {
                            _selectedProject = null;
                          });
                          setState(() {
                            _selectedProject = newValue;
                            _selectedIssue = null;
                          });
                          if (newValue != null)
                            _presenter.getIssues(newValue.id);
                        },
                        items: _projects
                            .map<DropdownMenuItem<Project>>((Project proj) {
                          return DropdownMenuItem<Project>(
                            value: proj,
                            child: Text(proj.name),
                          );
                        }).toList(),
                      ),
                      DropdownButton<Issue>(
                        isExpanded: true,
                        value: _selectedIssue,
                        hint: new Text("Select Issue"),
                        style: TextStyle(color: Colors.white),
                        underline: Container(
                          height: 2,
                          color: Colors.tealAccent,
                        ),
                        onChanged: (Issue newValue) {
                          setState(() {
                            _selectedIssue = newValue;
                          });
                        },
                        items:
                            _issues.map<DropdownMenuItem<Issue>>((Issue issue) {
                          return DropdownMenuItem<Issue>(
                            value: issue,
                            child: Text(issue.subject),
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                              onPressed: _handleDateSelection,
                              child: Text(_displayDate,
                                  style: TextStyle(color: Colors.white))),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "Hours"),
                              onChanged: _handleHoursChange,
                              initialValue: _hours,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          DropdownButton<Activity>(
                            value: _selectedActivity,
                            hint: new Text("Select Activity"),
                            style: TextStyle(color: Colors.white),
                            underline: Container(
                              height: 2,
                              color: Colors.tealAccent,
                            ),
                            onChanged: (Activity newValue) {
                              setState(() {
                                _selectedActivity = newValue;
                              });
                            },
                            items: _activites.map<DropdownMenuItem<Activity>>(
                                (Activity value) {
                              return DropdownMenuItem<Activity>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          new TextFormField(
                            minLines: 5,
                            maxLines: 20,
                            decoration:
                                InputDecoration(labelText: "Description"),
                            initialValue: _description,
                            onChanged: _handleDescChange,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Expanded(
                            child: MaterialButton(
                              onPressed: saveData,
                              height: 40.0,
                              minWidth: 30.0,
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: new Text("Ok"),
                              splashColor: Colors.redAccent,
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(30.0),
                          ),
                          new Expanded(
                            child: MaterialButton(
                              onPressed: (() => {}),
                              height: 40.0,
                              minWidth: 30.0,
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              child: new Text("Cancel"),
                              splashColor: Colors.teal,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  void onErrorIssues(String errorTxt) {
    Toast.show(errorTxt, _ctx,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black12);
  }

  @override
  void onErrorProjects(String errorTxt) {
    Toast.show(errorTxt, _ctx,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black12);
  }

  @override
  void onLoadIssues(List<Issue> issues) {
    _issues = new List<Issue>();
    setState(() => _issues = issues);
  }

  @override
  void onLoadProjects(List<Project> projects) {
    setState(() => _projects = projects);
  }

  @override
  void onErrorActivites(String errorTxt) {
    Toast.show(errorTxt, _ctx,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black12);
  }

  @override
  void onLoadActivites(List<Activity> activites) {
    setState(() {
      _activites = activites;
    });
  }

  @override
  void saveData() {
    _presenter.saveTicket(_selectedProject, _selectedIssue, _selectedActivity,
        _selectedDate, _description, _hours);
  }

  @override
  void onSaveError(String errorTxt) {
    Toast.show(errorTxt, _ctx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void _handleHoursChange(String value) {
    setState(() {
      _hours = value;
    });
  }

  void _handleDescChange(String value) {
    setState(() {
      _description = value;
    });
  }

  @override
  void onEntrySaved() {
    Navigator.of(_ctx).pushReplacement(
        new MaterialPageRoute(builder: (ctx) => new TimeEntry()));
  }
}
