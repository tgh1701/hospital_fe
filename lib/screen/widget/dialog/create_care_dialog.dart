import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/controller/care.dart';
import 'package:hospital_fe/controller/disease.dart';
import 'package:hospital_fe/controller/doctor.dart';
import 'package:hospital_fe/controller/nurse.dart';
import 'package:hospital_fe/controller/patient.dart';
import 'package:hospital_fe/controller/visit.dart';
import 'package:intl/intl.dart';

class CreateCareDialog extends StatefulWidget {
  const CreateCareDialog({super.key});

  @override
  State<CreateCareDialog> createState() => _CreateCareDialogState();
}

class _CreateCareDialogState extends State<CreateCareDialog> {
  final _formKey = GlobalKey<FormState>();

  final NurseController nurseController = Get.put(NurseController());
  final CareController careController = Get.put(CareController());
  final VisitController visitController = Get.put(VisitController());

  String? selectedVisit;
  String? selectedNurse;
  String? selectedDisease;

  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedDateOutController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    nurseController.getNurse();
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
                'Tạo chăm sóc',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(careController.careIdController, 'Mã chăm sóc'),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chọn lần khám'),
                  value: selectedVisit,
                  items: visitController.rxListVisit
                      .where((e) => e.nurseName == null)
                      .map((e) {
                    return DropdownMenuItem<String>(
                      value: e.visitId,
                      child: Text(e.visitId ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVisit = value;
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
                  decoration: const InputDecoration(labelText: 'Chọn y tá'),
                  value: selectedNurse,
                  items: nurseController.rxListNurse.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.nurseId,
                      child: Text(e.nurseName ?? "N/A"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedNurse = value;
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
              _buildDateInputField(selectedDateController, 'Ngày chăm sóc'),
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
                    child: const Text('Tạo',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedDateController.text.isNotEmpty) {
                          careController.postCare(
                            selectedVisit!,
                            selectedNurse!,
                            selectedDateController.text,
                          );
                          Navigator.of(context).pop();
                        } else {
                          Get.snackbar(
                              "Lỗi", "Vui lòng chọn ngày vào và ngày ra",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
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

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
