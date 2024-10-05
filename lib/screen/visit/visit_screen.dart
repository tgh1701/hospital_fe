import 'package:hospital_fe/controller/prescription.dart';
import 'package:hospital_fe/controller/visit.dart';
import 'package:hospital_fe/model/prescription.dart';
import 'package:hospital_fe/model/visit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/screen/widget/dialog/create_care_dialog.dart';
import 'package:hospital_fe/screen/widget/dialog/create_visit_dialog.dart';
import 'package:hospital_fe/screen/widget/editable_data_cell_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hospital_fe/util/logger.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  final VisitController visitController = Get.put(VisitController());
  final TextEditingController searchController = TextEditingController();
  final PrescriptionController prescriptionController =
      Get.put(PrescriptionController());
  final RxString searchQuery = ''.obs;

  String? editingVisitId;
  Visit? originalVisit;

  @override
  void initState() {
    super.initState();
    visitController.getVisit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showConfirmEdit(Visit visit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thông tin lượt thăm khám'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // visitController.putVisit(visit);
                // setState(() {
                //   editingVisitId = null;
                // });
                Navigator.pop(context);
              },
              child: const Text('Sửa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPrescriptionInfoDialog(String visitId) async {
    await prescriptionController.getPrescription(visitId);
    if (prescriptionController.rxListPrescription.isNotEmpty) {
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
                'Thông tin chi tiết đơn thuốc',
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
                itemCount: prescriptionController.rxListPrescription.length,
                itemBuilder: (context, index) {
                  final prescription =
                      prescriptionController.rxListPrescription[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Thuốc: ${prescription.medicineName}',
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
                            child: _buildPrescriptionDetails(prescription),
                          ),
                        ),
                        const Divider(
                          color: Colors.blueAccent,
                          thickness: 1,
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
      AppLogger.debug("Không có thông tin đơn thuốc.");
    }
  }

  Widget _buildPrescriptionDetails(Prescription prescription) {
    return DataTable(
      headingRowHeight: 0,
      horizontalMargin: 16,
      columnSpacing: 20,
      dataRowHeight: 40,
      columns: const [
        DataColumn(
          label: SizedBox.shrink(),
        ),
        DataColumn(
          label: SizedBox.shrink(),
        ),
      ],
      rows: [
        _buildDataRow('Tên bệnh nhân:', prescription.patientName ?? 'N/A'),
        _buildDataRow('Tên bác sĩ:', prescription.doctorName ?? 'N/A'),
        _buildDataRow('Ngày vào viện:', prescription.dateIn ?? 'N/A'),
        _buildDataRow('Ngày ra viện:', prescription.dateOut ?? 'N/A'),
        _buildDataRow('Tên thuốc:', prescription.medicineName ?? 'N/A'),
        _buildDataRow('Số lượng:', '${prescription.quantity ?? 0}'),
        _buildDataRow(
            'Giá:', '${prescription.price?.toStringAsFixed(0) ?? '0'} VNĐ'),
        _buildDataRow('Tổng giá thuốc:',
            '${prescription.totalMedicinePrice?.toStringAsFixed(0) ?? '0'} VNĐ'),
        _buildDataRow('Tổng chi phí:',
            '${prescription.totalPrice?.toStringAsFixed(0) ?? '0'} VNĐ'),
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
                      labelText: 'Tìm kiếm lượt thăm khám',
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
                        return const CreateCareDialog();
                      },
                    );
                  },
                  child: const Text(
                    'Thêm chăm sóc',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                        return const CreateVisitDialog();
                      },
                    );
                  },
                  child: const Text(
                    'Thêm lần khám',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final filteredVisits = visitController.rxListVisit
                  .where((visit) =>
                      visit.patientName!
                          .toLowerCase()
                          .contains(searchQuery.value) ||
                      visit.doctorName!
                          .toLowerCase()
                          .contains(searchQuery.value) ||
                      visit.diseaseName!
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
                    label: Center(child: Text('Tên bác sĩ')),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Tên bệnh')),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Ngày nhập viện')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Ngày xuất viện')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Tổng chi phí')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Trạng thái')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Tên y tá')),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Hành động')),
                    size: ColumnSize.S,
                    fixedWidth: 100,
                  ),
                ],
                rows: List<DataRow>.generate(
                  filteredVisits.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            filteredVisits[index].visitId.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].patientName.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.blue[200]!,
                          onChanged: (value) {
                            filteredVisits[index].patientName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].doctorName.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.green[200]!,
                          onChanged: (value) {
                            filteredVisits[index].doctorName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].diseaseName.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.orange[200]!,
                          onChanged: (value) {
                            filteredVisits[index].diseaseName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredVisits[index].dateIn.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.purple[200]!,
                          onChanged: (value) {
                            filteredVisits[index].dateIn = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].dateOut.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.yellow[200]!,
                          onChanged: (value) {
                            filteredVisits[index].dateOut = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].totalPrice.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.teal[200]!,
                          onChanged: (value) {
                            filteredVisits[index].totalPrice = int.parse(value);
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredVisits[index].status.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.red[200]!,
                          onChanged: (value) {
                            filteredVisits[index].status = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue:
                              filteredVisits[index].nurseName.toString(),
                          editMode:
                              editingVisitId == filteredVisits[index].visitId,
                          fillColor: Colors.brown[200]!,
                          onChanged: (value) {
                            filteredVisits[index].nurseName = value;
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
                            if (editingVisitId != filteredVisits[index].visitId)
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showPrescriptionInfoDialog(
                                      filteredVisits[index].visitId!);
                                },
                                splashRadius: 20,
                                hoverColor: Colors.grey[50],
                              ),
                            IconButton(
                              icon: Icon(
                                editingVisitId == filteredVisits[index].visitId
                                    ? Icons.check
                                    : Icons.edit,
                                color: editingVisitId ==
                                        filteredVisits[index].visitId
                                    ? Colors.green
                                    : Colors.blue,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (editingVisitId ==
                                      filteredVisits[index].visitId) {
                                    final editedVisit = Visit(
                                      visitId: filteredVisits[index].visitId,
                                      patientName:
                                          filteredVisits[index].patientName,
                                      doctorName:
                                          filteredVisits[index].doctorName,
                                      diseaseName:
                                          filteredVisits[index].diseaseName,
                                      dateIn: filteredVisits[index].dateIn,
                                      dateOut: filteredVisits[index].dateOut,
                                      totalPrice:
                                          filteredVisits[index].totalPrice,
                                      status: filteredVisits[index].status,
                                      nurseName:
                                          filteredVisits[index].nurseName,
                                    );
                                    _showConfirmEdit(editedVisit);
                                  } else {
                                    editingVisitId =
                                        filteredVisits[index].visitId;
                                  }
                                });
                              },
                              splashRadius: 20,
                              hoverColor: Colors.blue[50],
                            ),
                            if (editingVisitId == filteredVisits[index].visitId)
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await visitController.getVisit();
                                  setState(() {
                                    editingVisitId = null;
                                  });
                                },
                                splashRadius: 20,
                                hoverColor: Colors.red[50],
                              ),
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
