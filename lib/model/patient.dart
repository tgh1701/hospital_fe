class Patient {
  String? patientId;
  String? identityCard;
  String? patientName;
  String? dateOfBirth;
  String? address;
  String? phone;

  Patient({
    this.patientId,
    this.identityCard,
    this.patientName,
    this.dateOfBirth,
    this.address,
    this.phone,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    identityCard = json['identityCard'];
    patientName = json['patientName'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientId != null) {
      data['patientId'] = patientId;
    }
    if (identityCard != null) {
      data['identityCard'] = identityCard;
    }
    if (patientName != null) {
      data['patientName'] = patientName;
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
