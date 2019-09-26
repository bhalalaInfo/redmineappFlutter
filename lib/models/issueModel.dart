class Issue {
  int _id;
  String _subject;
  DateTime _startDate;
  DateTime _dueDate;

  int get id => _id;
  String get subject => _subject;

  Issue.fromJson(dynamic json) {
    _id = json["id"];
    _subject = json["subject"];
    _startDate = json["startDate"];
    _dueDate = json["dueDate"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["subject"] = _subject;
    map["startDate"] = _startDate;
    map["dueDate"] = _dueDate;

    return map;
  }
}
