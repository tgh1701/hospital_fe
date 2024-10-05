class Department {
  String? departmentId;
  String? departmentName;

  Department({
    this.departmentId,
    this.departmentName,
  });

  Department.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (departmentId != null) {
      data['departmentId'] = departmentId;
    }
    if (departmentName != null) {
      data['departmentName'] = departmentName;
    }
    return data;
  }
}
