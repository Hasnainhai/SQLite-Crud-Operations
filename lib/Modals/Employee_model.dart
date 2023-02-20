Employee toEmployee(Map<String, Object?> map) => Employee.toEmp(map);

class Employee {
  final int epId;
  final String epName;
  final String epDesignation;
  final bool isMale;

  Employee({
    required this.epId,
    required this.epName,
    required this.epDesignation,
    required this.isMale,
  });
  // convert to map
  Map<String, dynamic> toMap() => {
        "id": epId,
        "name": epName,
        "design": epDesignation,
        "isMale": isMale,
      };
  //convery Map to Employee
  factory Employee.toEmp(Map<String, dynamic> map) => Employee(
      epId: map["id"],
      epName: map["name"],
      epDesignation: map["design"],
      isMale: map["isMale"] == 1 ? true : false);
}
