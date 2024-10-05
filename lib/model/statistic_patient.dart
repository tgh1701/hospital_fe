class StatisticsPatient {
  String? patientName;
  String? visitId;
  String? dateIn;
  String? dateOut;
  String? diseaseName;
  double? totalPrice;
  int? visitSequence;
  String? status;

  StatisticsPatient({
    this.patientName,
    this.visitId,
    this.dateIn,
    this.dateOut,
    this.diseaseName,
    this.totalPrice,
    this.visitSequence,
    this.status,
  });

  StatisticsPatient.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    visitId = json['visitId'];
    dateIn = json['dateIn'];
    dateOut = json['dateOut'];
    diseaseName = json['diseaseName'];
    totalPrice = json['totalPrice'];
    visitSequence = json['visitSequence'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientName != null) {
      data['patientName'] = patientName;
    }
    if (visitId != null) {
      data['visitId'] = visitId;
    }
    if (dateIn != null) {
      data['dateIn'] = dateIn;
    }
    if (dateOut != null) {
      data['dateOut'] = dateOut;
    }
    if (diseaseName != null) {
      data['diseaseName'] = diseaseName;
    }
    if (totalPrice != null) {
      data['totalPrice'] = totalPrice;
    }
    if (visitSequence != null) {
      data['visitSequence'] = visitSequence;
    }
    if (status != null) {
      data['status'] = status;
    }
    return data;
  }
}
