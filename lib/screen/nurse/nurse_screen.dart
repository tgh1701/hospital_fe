import 'package:hospital_fe/controller/nurse.dart';
import 'package:hospital_fe/model/nurse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/screen/widget/dialog/create_nurse_dialog.dart';
import 'package:hospital_fe/screen/widget/editable_data_cell_widget.dart';
import 'package:data_table_2/data_table_2.dart';

class NurseScreen extends StatefulWidget {
  const NurseScreen({super.key});

  @override
  State<NurseScreen> createState() => _NurseScreenState();
}

class _NurseScreenState extends State<NurseScreen> {
  final NurseController nurseController = Get.put(NurseController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  String? editingNurseId;
  Nurse? originalNurse;

  @override
  void initState() {
    super.initState();
    nurseController.getNurse();
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showConfirmEdit(Nurse nurse) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thông tin y tá'),
          content: const Text('Bạn đã chắc chắn chưa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                nurseController.putNurse(nurse);
                setState(() {
                  editingNurseId = null;
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

  void _showConfirmDelete(String nurseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa thông tin y tá'),
          content: const Text('Bạn có chắc chắn muốn xóa thông tin y tá này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await nurseController.deleteNurse(nurseId);
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
                      labelText: 'Tìm kiếm y tá',
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
                      builder: (context) => const CreateNurseDialog(),
                    );
                  },
                  child: const Text(
                    'Thêm y tá',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final filteredNurses = nurseController.rxListNurse
                  .where((nurse) =>
              nurse.nurseName!.toLowerCase().contains(searchQuery.value))
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
                    label: Center(child: Text('Tên y tá')),
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
                    label: Center(child: Text('Thâm niên')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Trình độ')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Điện thoại')),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Hành động')),
                    size: ColumnSize.S,
                    fixedWidth: 100,
                  ),
                ],
                rows: List<DataRow>.generate(
                  filteredNurses.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            filteredNurses[index].nurseId.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].nurseName.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.blue[200]!,
                          onChanged: (value) {
                            filteredNurses[index].nurseName = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].identityCard.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.green[200]!,
                          onChanged: (value) {
                            filteredNurses[index].identityCard = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].dateOfBirth.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.orange[200]!,
                          onChanged: (value) {
                            filteredNurses[index].dateOfBirth = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].address.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.purple[200]!,
                          onChanged: (value) {
                            filteredNurses[index].address = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].seniority.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.yellow[200]!,
                          onChanged: (value) {
                            filteredNurses[index].seniority = int.parse(value);
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].level.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.brown[200]!,
                          onChanged: (value) {
                            filteredNurses[index].level = value;
                          },
                          editStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          displayStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        EditableDataCellWidget(
                          initialValue: filteredNurses[index].phone.toString(),
                          editMode: editingNurseId == filteredNurses[index].nurseId,
                          fillColor: Colors.teal[200]!,
                          onChanged: (value) {
                            filteredNurses[index].phone = value;
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
                            if (editingNurseId == filteredNurses[index].nurseId) ...[
                              // Icon check và close khi đang chỉnh sửa
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final editedNurse = Nurse(
                                      nurseId: filteredNurses[index].nurseId,
                                      nurseName: filteredNurses[index].nurseName,
                                      identityCard: filteredNurses[index].identityCard,
                                      dateOfBirth: filteredNurses[index].dateOfBirth,
                                      address: filteredNurses[index].address,
                                      seniority: filteredNurses[index].seniority,
                                      level: filteredNurses[index].level,
                                      phone: filteredNurses[index].phone,
                                    );
                                    _showConfirmEdit(editedNurse);
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
                                  await nurseController.getNurse();
                                  setState(() {
                                    editingNurseId = null;
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
                                    editingNurseId = filteredNurses[index].nurseId;
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
                                  _showConfirmDelete(filteredNurses[index].nurseId!);
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
