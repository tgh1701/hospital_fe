import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Để sử dụng FilteringTextInputFormatter
import 'package:intl/intl.dart'; // Để định dạng ngày tháng
import 'package:hospital_fe/controller/nurse.dart';

class CreateNurseDialog extends StatefulWidget {
  const CreateNurseDialog({super.key});

  @override
  State<CreateNurseDialog> createState() => _CreateNurseDialogState();
}

class _CreateNurseDialogState extends State<CreateNurseDialog> {
  final _formKey = GlobalKey<FormState>();

  final NurseController nurseController = Get.put(NurseController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(width: 500, child: contentBox(context)),
    );
  }

  Widget contentBox(context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 10), blurRadius: 15),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Thêm y tá',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(nurseController.nurseIdController, 'Mã Y Tá'),
              _buildInputField(
                nurseController.identityCardController,
                'Số CMND/CCCD',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildInputField(nurseController.nurseNameController, 'Tên Y Tá'),
              _buildDateInputField(nurseController.dateOfBirthController, 'Ngày Sinh (YYYY-MM-DD)'),
              _buildInputField(nurseController.addressController, 'Địa Chỉ'),
              _buildInputField(nurseController.seniorityController, 'Thâm niên (Số năm)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              _buildInputField(nurseController.levelController, 'Trình Độ'),
              _buildInputField(nurseController.phoneController, 'Điện Thoại',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
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
          title: const Text('Thêm y tá'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await nurseController.postNurse();
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

  Widget _buildDateInputField(
      TextEditingController controller, String label) {
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
