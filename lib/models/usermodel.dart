
class UserInfo {
  late String _login;
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;

  String get Login => _login;

  String get FirstName => _firstName;
  String get LastName => _lastName;

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
