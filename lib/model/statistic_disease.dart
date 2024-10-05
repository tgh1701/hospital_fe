class StatisticsDisease {
  String? diseaseName;
  int? patientCount;

  StatisticsDisease({
    this.diseaseName,
    this.patientCount,
  });

  StatisticsDisease.fromJson(Map<String, dynamic> json) {
    diseaseName = json['diseaseName'];
    patientCount = json['patientCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (diseaseName != null) {
      data['diseaseName'] = diseaseName;
    }
    if (patientCount != null) {
      data['patientCount'] = patientCount;
    }
    return data;
  }
}
