class Project {
  String identifier;
  int id;
  String name;
  String description;
  int status;

  int get Id => id;
  String get Name => name;

  Project(
      {required this.id,
      required this.name,
      required this.description,
      required this.identifier,
      required this.status});

  factory Project.fromJson(dynamic json) => Project(
        id: json["id"],
        identifier: json["identifier"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["identifier"] = identifier;
    map["name"] = name;
    map["description"] = description;
    map["status"] = status;

    return map;
  }
}
