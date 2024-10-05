class Nurse {
  String? nurseId;
  String? identityCard;
  String? nurseName;
  String? level;
  int? seniority;
  String? dateOfBirth;
  String? address;
  String? phone;

  Nurse({
    this.nurseId,
    this.identityCard,
    this.nurseName,
    this.level,
    this.seniority,
    this.dateOfBirth,
    this.address,
    this.phone,
  });

  Nurse.fromJson(Map<String, dynamic> json) {
    nurseId = json['nurseId'];
    identityCard = json['identityCard'];
    nurseName = json['nurseName'];
    level = json['level'];
    seniority = json['seniority'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nurseId != null) {
      data['nurseId'] = nurseId;
    }
    if (identityCard != null) {
      data['identityCard'] = identityCard;
    }
    if (nurseName != null) {
      data['nurseName'] = nurseName;
    }
    if (level != null) {
      data['level'] = level;
    }
    if (seniority != null) {
      data['seniority'] = seniority;
    }
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    return data;
  }
}
