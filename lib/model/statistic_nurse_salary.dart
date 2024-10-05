class StatisticsNurseSalary {
  String? nurseName;
  double? salary;

  StatisticsNurseSalary({
    this.nurseName,
    this.salary,
  });

  StatisticsNurseSalary.fromJson(Map<String, dynamic> json) {
    nurseName = json['nurseName'];
    salary = json['salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nurseName != null) {
      data['nurseName'] = nurseName;
    }
    if (salary != null) {
      data['salary'] = salary;
    }
    return data;
  }
}
