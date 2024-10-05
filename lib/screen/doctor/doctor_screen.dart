import 'package:hospital_fe/controller/doctor.dart';
import 'package:hospital_fe/model/doctor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/screen/widget/dialog/create_doctor_dialog.dart';
import 'package:hospital_fe/screen/widget/editable_data_cell_widget.dart';
import 'package:data_table_2/data_table_2.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final DoctorController doctorController = Get.put(DoctorController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  String? editingDoctorId;
  Doctor? originalDoctor;

  @override
  void initState() {
    super.initState();
    doctorController.getDoctor();
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showConfirmEdit(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thông tin bác sĩ'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                doctorController.putDoctor(doctor);
                setState(() {
                  editingDoctorId = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Sửa'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDelete(String doctorId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa bác sĩ'),
          content: const Text('Bạn có chắc chắn muốn xóa bác sĩ này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await doctorController.deleteDoctor(doctorId);
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm bác sĩ',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    fixedSize: const Size(160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CreateDoctorDialog();
                      },
                    );
                  },
                  child: const Text(
                    'Thêm bác sỹ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final filteredDoctors = doctorController.rxListDoctor
                  .where((doctor) =>
              doctor.doctorName!.toLowerCase().contains(searchQuery.value) ||
                  doctor.departmentId!.toLowerCase().contains(searchQuery.value))
                  .toList();

              return DataTable2(
                columnSpacing: 0,
                horizontalMargin: 0,
                border: TableBorder.all(width: 1.0, color: Colors.grey),
                minWidth: 800,
                columns: const [
                  DataColumn2(
                    label: Center(child: Text('ID')),
                    size: ColumnSize.S,
                    fixedWidth: 40,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Tên bác sĩ')),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Số CCCD')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Ngày sinh')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Địa chỉ')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Cấp độ nghề nghiệp')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Thâm niên')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Trình độ')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Phòng ban')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Hành động')),
                    size: ColumnSize.S,
                    fixedWidth: 100,
                  ),
                ],
                rows: List<DataRow>.generate(
                  filteredDoctors.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            filteredDoctors[index].doctorId.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].doctorName.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.blue[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].doctorName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].identityCard.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.green[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].identityCard = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].dateOfBirth.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.orange[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].dateOfBirth = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].address.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.purple[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].address = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].careerLevel.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.red[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].careerLevel = int.parse(value);
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].seniority.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.yellow[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].seniority = int.parse(value);
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].level.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.brown[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].level = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredDoctors[index].departmentId.toString(),
                          editMode: editingDoctorId == filteredDoctors[index].doctorId,
                          fillColor: Colors.teal[200]!,
                          onChanged: (value) {
                            filteredDoctors[index].departmentId = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (editingDoctorId == filteredDoctors[index].doctorId) ...[
                              // Icon check và close khi đang chỉnh sửa
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final editedDoctor = Doctor(
                                      doctorId: filteredDoctors[index].doctorId,
                                      doctorName: filteredDoctors[index].doctorName,
                                      identityCard: filteredDoctors[index].identityCard,
                                      dateOfBirth: filteredDoctors[index].dateOfBirth,
                                      address: filteredDoctors[index].address,
                                      careerLevel: filteredDoctors[index].careerLevel,
                                      seniority: filteredDoctors[index].seniority,
                                      level: filteredDoctors[index].level,
                                      departmentId: filteredDoctors[index].departmentId,
                                    );
                                    _showConfirmEdit(editedDoctor);
                                  });
                                },
                                splashRadius: 20,
                                hoverColor: Colors.green[50],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await doctorController.getDoctor();
                                  setState(() {
                                    editingDoctorId = null;
                                  });
                                },
                                splashRadius: 20,
                                hoverColor: Colors.red[50],
                              ),
                            ] else ...[
                              // Icon edit và delete khi không trong chế độ chỉnh sửa
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    editingDoctorId = filteredDoctors[index].doctorId;
                                  });
                                },
                                splashRadius: 20,
                                hoverColor: Colors.blue[50],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showConfirmDelete(filteredDoctors[index].doctorId!);
                                },
                                splashRadius: 20,
                                hoverColor: Colors.red[50],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
