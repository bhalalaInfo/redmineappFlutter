class Project {
  String _identifier;
  int _id;
  String _name;
  String _description;
  int _status;

  int get id => _id;
  String get name => _name;

  Project.fromJson(dynamic json) {
    _id = json["id"];
    _identifier = json["identifier"];
    _name = json["name"];
    _description = json["description"];
    _status = json["status"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["identifier"] = _identifier;
    map["name"] = _name;
    map["description"] = _description;
    map["status"] = _status;

    return map;
  }
}
