class Disease {
  String? diseaseId;
  String? diseaseName;
  String? departmentId;

  Disease({
    this.diseaseId,
    this.diseaseName,
    this.departmentId,
  });

  Disease.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    diseaseName = json['diseaseName'];
    departmentId = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (diseaseId != null) {
      data['diseaseId'] = diseaseId;
    }
    if (diseaseName != null) {
      data['diseaseName'] = diseaseName;
    }
    if (departmentId != null) {
      data['department'] = departmentId;
    }
    return data;
  }
}
