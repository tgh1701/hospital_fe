class Medicine {
  String? medicineId;
  String? medicineName;
  int? price;

  Medicine({
    this.medicineId,
    this.medicineName,
    this.price,
  });

  Medicine.fromJson(Map<String, dynamic> json) {
    medicineId = json['medicineId'];
    medicineName = json['medicineName'];
    price = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicineId != null) {
      data['medicineId'] = medicineId;
    }
    if (medicineName != null) {
      data['medicineName'] = medicineName;
    }
    if (price != null) {
      data['department'] = price;
    }
    return data;
  }
}
