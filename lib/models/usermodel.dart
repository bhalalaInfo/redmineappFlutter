
class UserInfo {
  String _login;
  String _firstName;
  String _lastName;
  String _email;
  String _password;

  String get login => _login;

  String get firstName => _firstName;
  String get lastName => _lastName;

  String get email => _email;

  UserInfo.fromJson(dynamic parsedJson) {
    _firstName = parsedJson['firstname'];
    _lastName = parsedJson['lastname'];
    _email = parsedJson['email'];
    _password = parsedJson['password'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["firstname"] = _firstName;
    map["lastname"] = _lastName;
    map["email"] = _email;
    map['password'] = _password;

    return map;
  }
}
