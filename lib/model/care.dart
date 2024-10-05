class Care {
  String? careId;
  String? visitId;
  String? nurseId;
  String? dateCare;

  Care({
    this.careId,
    this.visitId,
    this.nurseId,
    this.dateCare,
  });

  Care.fromJson(Map<String, dynamic> json) {
    careId = json['careId'];
    visitId = json['visitId'];
    nurseId = json['nurseId'];
    dateCare = json['dateCare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (careId != null) {
      data['careId'] = careId;
    }
    if (visitId != null) {
      data['visitId'] = visitId;
    }
    if (nurseId != null) {
      data['nurseId'] = nurseId;
    }
    if (dateCare != null) {
      data['dateCare'] = dateCare;
    }
    return data;
  }
}
