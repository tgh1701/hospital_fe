import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/controller/statistic.dart';
import 'package:intl/intl.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final StatisticController statisticController =
      Get.put(StatisticController());
  final dateFormat = DateFormat('yyyy-MM-dd');

  DateTimeRange doctorDateRange = DateTimeRange(
    start: DateTime(2024, 9, 1),
    end: DateTime(2024, 9, 30),
  );

  DateTimeRange nurseDateRange = DateTimeRange(
    start: DateTime(2024, 9, 1),
    end: DateTime(2024, 9, 30),
  );

  DateTimeRange diseaseDateRange = DateTimeRange(
    start: DateTime(2024, 9, 1),
    end: DateTime(2024, 9, 30),
  );

  DateTimeRange revenueDateRange = DateTimeRange(
    start: DateTime(2024, 9, 1),
    end: DateTime(2024, 9, 30),
  );

  @override
  void initState() {
    super.initState();
    _fetchDoctorStatistics(doctorDateRange.start, doctorDateRange.end);
    _fetchNurseStatistics(nurseDateRange.start, nurseDateRange.end);
    _fetchDiseaseStatistics(diseaseDateRange.start, diseaseDateRange.end);
    _fetchRevenueStatistics(revenueDateRange.start, revenueDateRange.end);
  }

  void _fetchDoctorStatistics(DateTime startDate, DateTime endDate) {
    String formattedStartDate = dateFormat.format(startDate);
    String formattedEndDate = dateFormat.format(endDate);
    statisticController.getDoctorSalary(formattedStartDate, formattedEndDate);
  }

  void _fetchNurseStatistics(DateTime startDate, DateTime endDate) {
    String formattedStartDate = dateFormat.format(startDate);
    String formattedEndDate = dateFormat.format(endDate);
    statisticController.getNurseSalary(formattedStartDate, formattedEndDate);
  }

  void _fetchDiseaseStatistics(DateTime startDate, DateTime endDate) {
    String formattedStartDate = dateFormat.format(startDate);
    String formattedEndDate = dateFormat.format(endDate);
    statisticController.getDiseaseStatistics(
        formattedStartDate, formattedEndDate);
  }

  void _fetchRevenueStatistics(DateTime startDate, DateTime endDate) {
    String formattedStartDate = dateFormat.format(startDate);
    String formattedEndDate = dateFormat.format(endDate);
    statisticController.getRevenueStatistics(
        formattedStartDate, formattedEndDate);
  }

  Future<void> _selectDateRange(
      Function(DateTimeRange) onDateRangeSelected) async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            child: child,
          ),
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        onDateRangeSelected(newDateRange);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thống kê',
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0,
            children: [
              _buildTableStatisticCard(
                'Tổng lương bác sĩ',
                '${dateFormat.format(doctorDateRange.start)} - ${dateFormat.format(doctorDateRange.end)}',
                Obx(() {
                  if (statisticController.rxDoctorSalary.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu',
                          style: TextStyle(color: Colors.black54, fontSize: 16)),
                    );
                  }
                  return _buildDataTable(
                    statisticController.rxDoctorSalary
                        .map((e) => [
                              e.doctorName ?? "N/A",
                              '${e.salary?.toString() ?? "0"} VNĐ'
                            ])
                        .toList(),
                    ['Tên', 'Lương'],
                  );
                }),
                () => _selectDateRange((newDateRange) {
                  doctorDateRange = newDateRange;
                  _fetchDoctorStatistics(newDateRange.start, newDateRange.end);
                }),
              ),
              _buildTableStatisticCard(
                'Tổng lương y tá',
                '${dateFormat.format(nurseDateRange.start)} - ${dateFormat.format(nurseDateRange.end)}',
                Obx(() {
                  if (statisticController.rxNurseSalary.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu',
                          style: TextStyle(color: Colors.black54, fontSize: 16)),
                    );
                  }
                  return _buildDataTable(
                    statisticController.rxNurseSalary
                        .map((e) => [
                              e.nurseName ?? "N/A",
                              '${e.salary?.toString() ?? "0"} VNĐ'
                            ])
                        .toList(),
                    ['Tên', 'Lương'],
                  );
                }),
                () => _selectDateRange((newDateRange) {
                  nurseDateRange = newDateRange;
                  _fetchNurseStatistics(newDateRange.start, newDateRange.end);
                }),
              ),
              _buildTableStatisticCard(
                'Thống kê bệnh',
                '${dateFormat.format(diseaseDateRange.start)} - ${dateFormat.format(diseaseDateRange.end)}',
                Obx(() {
                  if (statisticController.rxDisease.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu',
                          style: TextStyle(color: Colors.black54, fontSize: 16)),
                    );
                  }
                  return _buildDataTable(
                    statisticController.rxDisease
                        .map((e) => [
                              e.diseaseName ?? "N/A",
                              '${e.patientCount ?? 0} bệnh nhân'
                            ])
                        .toList(),
                    ['Bệnh', 'Số bệnh nhân'],
                  );
                }),
                () => _selectDateRange((newDateRange) {
                  diseaseDateRange = newDateRange;
                  _fetchDiseaseStatistics(newDateRange.start, newDateRange.end);
                }),
              ),
              _buildRevenueCard(
                'Tổng doanh thu',
                '${dateFormat.format(revenueDateRange.start)} - ${dateFormat.format(revenueDateRange.end)}',
                Obx(() {
                  if (statisticController.totalRevenue.value == 0.0) {
                    return const Center(
                      child: Text('Không có dữ liệu',
                          style: TextStyle(color: Colors.black54, fontSize: 16)),
                    );
                  }
                  return Center(
                    child: Text(
                      '${statisticController.totalRevenue.value} VNĐ',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                () => _selectDateRange((newDateRange) {
                  revenueDateRange = newDateRange;
                  _fetchRevenueStatistics(newDateRange.start, newDateRange.end);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableStatisticCard(String title, String dateRange,
      Widget content, VoidCallback onDateRangeChanged) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range, color: Colors.blue),
                    onPressed: onDateRangeChanged,
                  ),
                ],
              ),
              Text(
                dateRange,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueCard(String title, String dateRange, Widget content,
      VoidCallback onDateRangeChanged) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range, color: Colors.blue),
                    onPressed: onDateRangeChanged,
                  ),
                ],
              ),
              Text(
                dateRange,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<List<String>> data, List<String> headers) {
    return Table(
      border: TableBorder.all(color: Colors.blueAccent),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
          children: headers
              .map((header) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      header,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ))
              .toList(),
        ),
        ...data.map((row) {
          return TableRow(
            children: row
                .map((cell) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cell,
                          style: const TextStyle(color: Colors.black87)),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }
}
