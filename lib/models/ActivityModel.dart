class Activity {
  int id;
  String name;

  Activity({required this.id, required this.name});

  factory Activity.fromJson(dynamic json) =>
      Activity(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}
