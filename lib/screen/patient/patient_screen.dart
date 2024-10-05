import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/controller/patient.dart';
import 'package:hospital_fe/controller/statistic.dart';
import 'package:hospital_fe/model/patient.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hospital_fe/model/statistic_patient.dart';
import 'package:hospital_fe/screen/widget/dialog/create_patient_dialog.dart';
import 'package:hospital_fe/screen/widget/editable_data_cell_widget.dart';
import 'package:hospital_fe/util/logger.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final PatientController patientController = Get.put(PatientController());
  final StatisticController statisticController =
      Get.put(StatisticController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  String? editingPatientId;
  Patient? originalPatient;

  @override
  void initState() {
    super.initState();
    patientController.getPatient();
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showConfirmEdit(Patient patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thông tin bệnh nhân'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                patientController.putPatient(patient);
                setState(() {
                  editingPatientId = null;
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

  void _showConfirmDelete(String patientId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa thông tin bệnh nhân'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa thông tin bệnh nhân này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await patientController.deletePatient(patientId);
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPatientInfoDialog(String patientId) async {
    await statisticController.getPatientInfo(patientId);
    if (statisticController.rxPatient.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Center(
              child: Text(
                'Thông tin chi tiết bệnh nhân',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            content: SizedBox(
              width: 400,
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: statisticController.rxPatient.length,
                itemBuilder: (context, index) {
                  final patientInfo = statisticController.rxPatient[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Lần khám ${patientInfo.visitSequence}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: IntrinsicWidth(
                            child: _buildDataTable(patientInfo),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      AppLogger.debug("Không có thông tin bệnh nhân.");
    }
  }

  Widget _buildDataTable(StatisticsPatient patientInfo) {
    return DataTable(
      headingRowHeight: 0,
      horizontalMargin: 16,
      columnSpacing: 20,
      columns: const [
        DataColumn(
          label: SizedBox.shrink(),
        ),
        DataColumn(
          label: SizedBox.shrink(),
        ),
      ],
      rows: [
        _buildDataRow('Tên bệnh nhân:', patientInfo.patientName ?? 'N/A'),
        _buildDataRow('Mã lần khám:', patientInfo.visitId ?? 'N/A'),
        _buildDataRow('Ngày vào viện:', patientInfo.dateIn ?? 'N/A'),
        _buildDataRow('Ngày ra viện:', patientInfo.dateOut ?? 'N/A'),
        _buildDataRow('Tên bệnh:', patientInfo.diseaseName ?? 'N/A'),
        _buildDataRow('Tổng chi phí:',
            '${patientInfo.totalPrice?.toStringAsFixed(0) ?? '0'} VNĐ'),
        _buildDataRow('Trạng thái:', patientInfo.status ?? 'N/A'),
      ],
    );
  }

  DataRow _buildDataRow(String label, String value) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        DataCell(
          Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
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
                      labelText: 'Tìm kiếm bệnh nhân',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
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
                        return const CreatePatientDialog();
                      },
                    );
                  },
                  child: const Text(
                    'Thêm bệnh nhân',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final filteredPatients = patientController.rxListPatient
                  .where((patient) =>
                      patient.patientName!
                          .toLowerCase()
                          .contains(searchQuery.value) ||
                      patient.address!
                          .toLowerCase()
                          .contains(searchQuery.value))
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
                    label: Center(child: Text('Tên bệnh nhân')),
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
                    label: Center(child: Text('Điện thoại')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Hành động')),
                    size: ColumnSize.S,
                    fixedWidth: 150,
                  ),
                ],
                rows: List<DataRow>.generate(
                  filteredPatients.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            filteredPatients[index].patientId.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredPatients[index].patientName.toString(),
                          editMode: editingPatientId ==
                              filteredPatients[index].patientId,
                          fillColor: Colors.blue[200]!,
                          onChanged: (value) {
                            filteredPatients[index].patientName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredPatients[index].identityCard.toString(),
                          editMode: editingPatientId ==
                              filteredPatients[index].patientId,
                          fillColor: Colors.green[200]!,
                          onChanged: (value) {
                            filteredPatients[index].identityCard = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredPatients[index].dateOfBirth.toString(),
                          editMode: editingPatientId ==
                              filteredPatients[index].patientId,
                          fillColor: Colors.orange[200]!,
                          onChanged: (value) {
                            filteredPatients[index].dateOfBirth = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredPatients[index].address.toString(),
                          editMode: editingPatientId ==
                              filteredPatients[index].patientId,
                          fillColor: Colors.purple[200]!,
                          onChanged: (value) {
                            filteredPatients[index].address = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredPatients[index].phone.toString(),
                          editMode: editingPatientId ==
                              filteredPatients[index].patientId,
                          fillColor: Colors.teal[200]!,
                          onChanged: (value) {
                            filteredPatients[index].phone = value;
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
                            // Hiển thị nút "View" chỉ khi không trong chế độ chỉnh sửa
                            if (editingPatientId !=
                                filteredPatients[index].patientId)
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showPatientInfoDialog(
                                      filteredPatients[index].patientId!);
                                },
                                splashRadius: 20,
                                hoverColor: Colors.grey[50],
                              ),
                            // Kiểm tra nếu đang chỉnh sửa, hiển thị nút "Check" và "Close"
                            if (editingPatientId ==
                                filteredPatients[index].patientId) ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final editedPatient = Patient(
                                      patientId:
                                          filteredPatients[index].patientId,
                                      patientName:
                                          filteredPatients[index].patientName,
                                      identityCard:
                                          filteredPatients[index].identityCard,
                                      dateOfBirth:
                                          filteredPatients[index].dateOfBirth,
                                      address: filteredPatients[index].address,
                                      phone: filteredPatients[index].phone,
                                    );
                                    _showConfirmEdit(editedPatient);
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
                                  await patientController.getPatient();
                                  setState(() {
                                    editingPatientId = null;
                                  });
                                },
                                splashRadius: 20,
                                hoverColor: Colors.red[50],
                              ),
                            ] else ...[
                              // Nếu không trong chế độ chỉnh sửa, hiển thị nút "Edit" và "Delete"
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    editingPatientId =
                                        filteredPatients[index].patientId;
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
                                  _showConfirmDelete(
                                      filteredPatients[index].patientId!);
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
