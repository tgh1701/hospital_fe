class Visit {
  String? visitId;
  String? patientName;
  String? doctorName;
  String? diseaseName;
  String? dateIn;
  String? dateOut;
  int? totalPrice;
  String? status;
  String? nurseName;

  Visit({
    this.visitId,
    this.patientName,
    this.doctorName,
    this.diseaseName,
    this.dateIn,
    this.dateOut,
    this.totalPrice,
    this.status,
    this.nurseName,
  });

  Visit.fromJson(Map<String, dynamic> json) {
    visitId = json['visitId'];
    patientName = json['patientName'];
    doctorName = json['doctorName'];
    diseaseName = json['diseaseName'];
    dateIn = json['dateIn'];
    dateOut = json['dateOut'];
    totalPrice = json['totalPrice'];
    status = json['status'];
    nurseName = json['nurseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (visitId != null) {
      data['visitId'] = visitId;
    }
    if (patientName != null) {
      data['patientName'] = patientName;
    }
    if (doctorName != null) {
      data['doctorName'] = doctorName;
    }
    if (diseaseName != null) {
      data['diseaseName'] = diseaseName;
    }
    if (dateIn != null) {
      data['dateIn'] = dateIn;
    }
    if (dateOut != null) {
      data['dateOut'] = dateOut;
    }
    if (totalPrice != null) {
      data['totalPrice'] = totalPrice;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (nurseName != null) {
      data['nurseName'] = nurseName;
    }
    return data;
  }
}
