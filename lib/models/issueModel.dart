class Issue {
  int id;
  String subject;
  DateTime startDate;
  DateTime dueDate;

  int get Id => id;
  String get Subject => subject;

  Issue(
      {required this.id,
      required this.subject,
      required this.startDate,
      required this.dueDate});

  factory Issue.fromJson(dynamic json) => Issue(
      id: json["id"],
      subject: json["subject"],
      startDate: json["startDate"],
      dueDate: json["dueDate"]);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["subject"] = subject;
    map["startDate"] = startDate;
    map["dueDate"] = dueDate;

    return map;
  }
}
