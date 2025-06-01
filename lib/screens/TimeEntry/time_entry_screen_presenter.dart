import 'package:redmineapp/data/rest_ds.dart';
import 'package:redmineapp/models/ActivityModel.dart';
import 'package:redmineapp/models/issueModel.dart';
import 'package:redmineapp/models/projectModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TimeEntryScreenContract {
  void onLoadProjects(List<Project> projects);
  void onErrorProjects(String errorTxt);

  void onLoadIssues(List<Issue> projects);
  void onErrorIssues(String errorTxt);

  void onLoadActivites(List<Activity> projects);
  void onErrorActivites(String errorTxt);

  void saveData();
  void onSaveError(String errorTxt);
  void onEntrySaved();
}

class TimeEntryScreenPresenter {
  TimeEntryScreenContract _view;
  RestDataSource api = new RestDataSource();
  TimeEntryScreenPresenter(this._view);

  getProjects() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var creds = pref.getString("Creds")!;
      var projects = await api.getProjects(pref.getString("BaseUrl")!, creds);
      _view.onLoadProjects(projects);
    } on Exception catch (error) {
      _view.onErrorProjects(error.toString());
    }
  }

  getIssues(int projectId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var creds = pref.getString("Creds")!;
      var issues =
          await api.getIssues(pref.getString("BaseUrl")!, creds, projectId);
      _view.onLoadIssues(issues);
    } on Exception catch (e) {
      _view.onErrorIssues(e.toString());
    }
  }

  getActivities() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var creds = pref.getString("Creds")!;
      var activities =
          await api.getActivities(pref.getString("BaseUrl")!, creds);
      _view.onLoadActivites(activities);
    } catch (e) {
      _view.onErrorActivites(e.toString());
    }
  }

  Future saveTicket(Project project, Issue issue, Activity activity,
      DateTime date, String desc, String hours) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var creds = pref.getString("Creds")!;

      await api.saveEntry(pref.getString("BaseUrl")!, creds, project.id,
          issue.id, activity.id, date, desc, double.parse(hours));
      _view.onEntrySaved();
    } catch (e) {
      _view.onSaveError(e.toString());
    }
  }
}
