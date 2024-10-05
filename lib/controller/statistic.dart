import 'dart:convert';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/statistic_disease.dart';
import 'package:hospital_fe/model/statistic_doctor_salary.dart';
import 'package:hospital_fe/model/statistic_nurse_salary.dart';
import 'package:hospital_fe/model/statistic_patient.dart';
import 'package:hospital_fe/model/statistic_revenue.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class StatisticController extends GetxController {
  RxList<StatisticsDoctorSalary> rxDoctorSalary =
      <StatisticsDoctorSalary>[].obs;
  RxList<StatisticsNurseSalary> rxNurseSalary = <StatisticsNurseSalary>[].obs;
  RxList<StatisticsDisease> rxDisease = <StatisticsDisease>[].obs;
  RxList<StatisticsPatient> rxPatient = <StatisticsPatient>[].obs;
  RxDouble totalRevenue = 0.0.obs;

  Future<RxList<StatisticsDoctorSalary>> getDoctorSalary(
      String startDate, String endDate) async {
    try {
      final url =
          '$apiStatistic/doctor-salaries?startDate=$startDate&endDate=$endDate';
      final response = await HttpService.getRequest(url, timeout: 30);
      // AppLogger.debug(url);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxDoctorSalary.value = result
              .map((item) => StatisticsDoctorSalary.fromJson(item))
              .toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxDoctorSalary);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<StatisticsNurseSalary>> getNurseSalary(
      String startDate, String endDate) async {
    try {
      final url =
          '$apiStatistic/nurse-salaries?startDate=$startDate&endDate=$endDate';
      final response = await HttpService.getRequest(url, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxNurseSalary.value = result
              .map((item) => StatisticsNurseSalary.fromJson(item))
              .toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxNurseSalary);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<StatisticsDisease>> getDiseaseStatistics(
      String startDate, String endDate) async {
    try {
      final url =
          '$apiStatistic/diseases?startDate=$startDate&endDate=$endDate';
      final response = await HttpService.getRequest(url, timeout: 30);
      // AppLogger.info(url);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxDisease.value =
              result.map((item) => StatisticsDisease.fromJson(item)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        rxDisease.clear();
      }else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxDisease);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<void> getRevenueStatistics(String startDate, String endDate) async {
    try {
      final url =
          '$apiStatistic/total-revenue?startDate=$startDate&endDate=$endDate';
      final response = await HttpService.getRequest(url, timeout: 30);
    AppLogger.info(url);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          totalRevenue.value = jsonResponse['result']['totalRevenue'];
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        totalRevenue.value = 0.0;
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
    } catch (e) {
      HttpService.handleHttpError(e);
    }
  }

  Future<void> getPatientInfo(String id) async {
    try {
      final url =
          '$apiStatistic/patient-info/$id';
      final response = await HttpService.getRequest(url, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxPatient.value = result
              .map((item) => StatisticsPatient.fromJson(item))
              .toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        totalRevenue.value = 0.0;
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
    } catch (e) {
      HttpService.handleHttpError(e);
    }
  }
}
