class StatisticsDoctorSalary {
  String? doctorName;
  double? salary;

  StatisticsDoctorSalary({
    this.doctorName,
    this.salary,
  });

  StatisticsDoctorSalary.fromJson(Map<String, dynamic> json) {
    doctorName = json['doctorName'];
    salary = json['salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctorName != null) {
      data['doctorName'] = doctorName;
    }
    if (salary != null) {
      data['salary'] = salary;
    }
    return data;
  }
}
