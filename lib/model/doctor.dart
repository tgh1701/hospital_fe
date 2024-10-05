class Doctor {
  String? doctorId;
  String? identityCard;
  String? doctorName;
  String? dateOfBirth;
  String? address;
  int? careerLevel;
  int? seniority;
  String? level;
  String? departmentId;

  Doctor({
    this.doctorId,
    this.identityCard,
    this.doctorName,
    this.dateOfBirth,
    this.address,
    this.careerLevel,
    this.seniority,
    this.level,
    this.departmentId,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    identityCard = json['identityCard'];
    doctorName = json['doctorName'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    careerLevel = json['careerLevel'];
    seniority = json['seniority'];
    level = json['level'];
    departmentId = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctorId != null) {
      data['doctorId'] = doctorId;
    }
    if (identityCard != null) {
      data['identityCard'] = identityCard;
    }
    if (doctorName != null) {
      data['doctorName'] = doctorName;
    }
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (careerLevel != null) {
      data['careerLevel'] = careerLevel;
    }
    if (seniority != null) {
      data['seniority'] = seniority;
    }
    if (level != null) {
      data['level'] = level;
    }
    if (departmentId != null) {
      data['department'] = departmentId;
    }
    return data;
  }
}
