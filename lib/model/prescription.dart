class Prescription {
  String? prescriptionId;
  String? medicineId;
  String? medicineName;
  int? quantity;
  int? price;
  int? totalMedicinePrice;
  int? totalPrice;
  String? patientName;
  String? doctorName;
  String? dateIn;
  String? dateOut;

  Prescription({
    this.prescriptionId,
    this.medicineId,
    this.medicineName,
    this.quantity,
    this.price,
    this.totalMedicinePrice,
    this.totalPrice,
    this.patientName,
    this.doctorName,
    this.dateIn,
    this.dateOut,
  });

  // Tạo đối tượng từ JSON
  Prescription.fromJson(Map<String, dynamic> json) {
    prescriptionId = json['PrescriptionID'];
    medicineId = json['MedicineID'];
    medicineName = json['MedicineName'];
    quantity = json['Quantity'];
    price = json['Price'];
    totalMedicinePrice = json['TotalMedicinePrice'];
    totalPrice = json['TotalPrice'];
    patientName = json['PatientName'];
    doctorName = json['DoctorName'];
    dateIn = json['DateIn'];
    dateOut = json['DateOut'];
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prescriptionId != null) {
      data['PrescriptionID'] = prescriptionId;
    }
    if (medicineId != null) {
      data['MedicineID'] = medicineId;
    }
    if (medicineName != null) {
      data['MedicineName'] = medicineName;
    }
    if (quantity != null) {
      data['Quantity'] = quantity;
    }
    if (price != null) {
      data['Price'] = price;
    }
    if (totalMedicinePrice != null) {
      data['TotalMedicinePrice'] = totalMedicinePrice;
    }
    if (totalPrice != null) {
      data['TotalPrice'] = totalPrice;
    }
    if (patientName != null) {
      data['PatientName'] = patientName;
    }
    if (doctorName != null) {
      data['DoctorName'] = doctorName;
    }
    if (dateIn != null) {
      data['DateIn'] = dateIn;
    }
    if (dateOut != null) {
      data['DateOut'] = dateOut;
    }
    return data;
  }
}
