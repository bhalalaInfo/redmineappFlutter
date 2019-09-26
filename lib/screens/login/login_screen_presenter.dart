import 'package:redmineapp/data/rest_ds.dart';
import 'package:redmineapp/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(UserInfo user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var user = await api.login(pref.get("BaseUrl"), username, password);
      _view.onLoginSuccess(user);
    } on Exception catch (error) {
      _view.onLoginError(error.toString());
    }
  }
}
