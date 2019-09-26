class Activity {
  int id;
  String name;

  Activity.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}
