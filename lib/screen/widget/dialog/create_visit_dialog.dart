import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/controller/disease.dart';
import 'package:hospital_fe/controller/doctor.dart';
import 'package:hospital_fe/controller/patient.dart';
import 'package:hospital_fe/controller/visit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CreateVisitDialog extends StatefulWidget {
  const CreateVisitDialog({super.key});

  @override
  State<CreateVisitDialog> createState() => _CreateVisitDialogState();
}

class _CreateVisitDialogState extends State<CreateVisitDialog> {
  final _formKey = GlobalKey<FormState>();

  final VisitController visitController = Get.put(VisitController());
  final DoctorController doctorController = Get.put(DoctorController());
  final PatientController patientController = Get.put(PatientController());
  final DiseaseController diseaseController = Get.put(DiseaseController());

  String? selectedPatient;
  String? selectedDoctor;
  String? selectedDisease;

  final TextEditingController selectedDateInController = TextEditingController();
  final TextEditingController selectedDateOutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    doctorController.getDoctor(); // Lấy danh sách bác sĩ
    patientController.getPatient(); // Lấy danh sách bệnh nhân
    diseaseController.getDisease(); // Lấy danh sách bệnh
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 500,
        child: contentBox(context),
      ),
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
                'Thêm lượt thăm khám',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(visitController.visitIdController, 'Mã lần khám'),
              _buildInputField(visitController.totalPriceController, 'Tổng chi phí', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              _buildInputField(visitController.statusController, 'Trạng thái'),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn bệnh nhân'),
                  value: selectedPatient,
                  items: patientController.rxListPatient.map((patient) {
                    return DropdownMenuItem<String>(
                      value: patient.patientId,
                      child: Text(patient.patientName ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPatient = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn bệnh nhân';
                    }
                    return null;
                  },
                );
              }),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn bác sĩ'),
                  value: selectedDoctor,
                  items: doctorController.rxListDoctor.map((doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.doctorId,
                      child: Text(doctor.doctorName ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDoctor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn bác sĩ';
                    }
                    return null;
                  },
                );
              }),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn bệnh'),
                  value: selectedDisease,
                  items: diseaseController.rxListDisease.map((disease) {
                    return DropdownMenuItem<String>(
                      value: disease.diseaseId,
                      child: Text(disease.diseaseName ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDisease = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn bệnh';
                    }
                    return null;
                  },
                );
              }),
              _buildDateInputField(selectedDateInController, 'Ngày vào viện'),
              _buildDateInputField(selectedDateOutController, 'Ngày xuất viện'),
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
          title: const Text('Thêm lượt thăm khám'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await visitController.postVisit(
                  selectedPatient!,
                  selectedDoctor!,
                  selectedDisease!,
                  selectedDateInController.text,
                  selectedDateOutController.text,
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

  Widget _buildDateInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn $label';
          }
          return null;
        },
      ),
    );
  }
}
