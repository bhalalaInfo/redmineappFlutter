import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:redmineapp/models/ActivityModel.dart';
import 'package:redmineapp/models/issueModel.dart';
import 'package:redmineapp/models/projectModel.dart';
import 'package:redmineapp/models/usermodel.dart';
import 'package:redmineapp/network/network.dart';

class RestDataSource {
  Network _netUtil = new Network();
  Future<UserInfo> login(String host, String userName, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$userName:$password'));

    return _netUtil
        .getWithHeaders(getUrl(host, "projects.json"),
            headers: <String, String>{
              'Authorization': basicAuth,
              'accept': 'application/json'
            },
            isResponse: false)
        .then((dynamic res) {
      if (res == null) {
        var user = new Map();
        user["firstname"] = userName;
        return UserInfo.fromJson(user);
      } else
        return null;
    }).catchError((error) {
      print(error);
      throw new Exception("Invalid User Information");
    });
  }

  Future<List<Project>> getProjects(String host, String creds) {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(creds));

    return _netUtil.getWithHeaders(getUrl(host, "projects.json"),
        headers: <String, String>{
          'Authorization': basicAuth
        }).then((dynamic res) {
      List<Project> projs = new List<Project>();
      res['projects']
          .forEach((dynamic element) => projs.add(Project.fromJson(element)));
      return projs;
    }).catchError((e) {
      print(e);
      throw new Exception("Error in getting projects");
    });
  }

  Future<List<Issue>> getIssues(String host, String creds, int projectId) {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(creds));

    return _netUtil.getWithHeaders(
        getUrl(host, 'issues.json?project_id=$projectId'),
        headers: <String, String>{
          'Authorization': basicAuth
        }).then((dynamic res) {
      List<Issue> issues = new List<Issue>();
      res['issues'].forEach((dynamic i) => issues.add(Issue.fromJson(i)));
      return issues;
    }).catchError((e) {
      print(e);
      throw new Exception("Erro in getting issues");
    });
  }

  Future<List<Activity>> getActivities(String host, String creds) {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(creds));

    return _netUtil.getWithHeaders(
        getUrl(host, 'enumerations/time_entry_activities.json'),
        headers: <String, String>{
          'Authorization': basicAuth
        }).then((dynamic res) {
      List<Activity> activities = new List<Activity>();
      res['time_entry_activities']
          .forEach((dynamic i) => activities.add(Activity.fromJson(i)));
      return activities;
    }).catchError((e) {
      print(e);
      throw new Exception("Erro in getting issues");
    });
  }

  Future<dynamic> saveEntry(String host, String creds, int projectId,
      int issueId, int activityId, DateTime date, String desc, double hours) {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(creds));
    var timeEntry = {
      "time_entry": {
        "id": null,
        "issue_id": issueId,
        "activity_id": activityId,
        "hours": hours,
        "comments": "Test",
        "spent_on": DateFormat("yyyy-MM-dd").format(date),
        "created_on": date.toString(),
        "updated_on": date.toString()
      }
    };

    var payload = json.encode(timeEntry);
    return _netUtil
        .post(getUrl(host, 'time_entries.json'),
            headers: <String, String>{
              'Authorization': basicAuth,
              'content-type': 'application/json'
            },
            body: payload)
        .then((dynamic res) {
      return res;
    }).catchError((Object e) {
      print(e);
      throw new Exception(e.toString());
    });
  }

  String getUrl(String baseUrl, String suffix) {
    if (!baseUrl.endsWith("/")) baseUrl = baseUrl + "/";
    return baseUrl + suffix;
  }
}
