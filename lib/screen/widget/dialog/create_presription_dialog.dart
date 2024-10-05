import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/controller/medicine.dart';
import 'package:hospital_fe/controller/prescription.dart';
import 'package:hospital_fe/controller/visit.dart';
import 'package:flutter/services.dart';

class CreatePrescriptionDialog extends StatefulWidget {
  const CreatePrescriptionDialog({super.key});

  @override
  State<CreatePrescriptionDialog> createState() =>
      _CreatePrescriptionDialogState();
}

class _CreatePrescriptionDialogState extends State<CreatePrescriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final VisitController visitController = Get.put(VisitController());
  final MedicineController medicineController = Get.put(MedicineController());

  String? selectedVisit;
  String? selectedMedicine;

  @override
  void initState() {
    super.initState();
    visitController.getVisit(); // Lấy danh sách lần khám
    medicineController.getMedicine(); // Lấy danh sách thuốc
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(width: 500, child: contentBox(context)),
    );
  }

  Widget contentBox(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 10),
              blurRadius: 15,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Thêm Đơn Thuốc',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(
                  prescriptionController.prescriptionIdController, 'Mã Đơn Thuốc'),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn lần khám'),
                  value: selectedVisit,
                  items: visitController.rxListVisit.map((visit) {
                    return DropdownMenuItem<String>(
                      value: visit.visitId,
                      child: Text(visit.visitId ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVisit = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn lần khám';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 15),
              _buildInputField(
                  prescriptionController.prescriptionMedicineIdController,
                  'Mã Chi Tiết Đơn Thuốc'),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn Thuốc'),
                  value: selectedMedicine,
                  items: medicineController.rxListMedicine.map((medicine) {
                    return DropdownMenuItem<String>(
                      value: medicine.medicineId,
                      child: Text(medicine.medicineName ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMedicine = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn thuốc';
                    }
                    return null;
                  },
                );
              }),
              _buildInputField(prescriptionController.quantityController,
                  'Số Lượng',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hủy',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text('Thêm',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showConfirmCreate();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Đơn Thuốc'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await prescriptionController.postPrescription(
                  selectedVisit!,
                  selectedMedicine!,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }
}
