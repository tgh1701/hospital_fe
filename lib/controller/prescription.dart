import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/prescription.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class PrescriptionController extends GetxController {
  RxList<Prescription> rxListPrescription = <Prescription>[].obs;

  final TextEditingController prescriptionIdController =
      TextEditingController();
  final TextEditingController prescriptionMedicineIdController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  Future<RxList<Prescription>> getPrescription(String id) async {
    try {
      final response =
          await HttpService.getRequest('$apiPrescription/$id', timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListPrescription.value =
              result.map((item) => Prescription.fromJson(item)).toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListPrescription);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Prescription>> postPrescription(
    String visitId,
    String medicineId,
  ) async {
    try {
      final data = {
        "prescriptionId": prescriptionIdController.text,
        "visitId": visitId,
      };
      final response =
          await HttpService.postRequest(apiPrescription, data, timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        final data1 = {
          "prescriptionMedicineId": prescriptionMedicineIdController.text,
          "prescriptionId": prescriptionIdController.text,
          "medicineId": medicineId,
          "quantity": quantityController.text,
        };
        final response1 = await HttpService.postRequest(
            apiPrescriptionMedicines, data1,
            timeout: 30);

        if (response1.statusCode == 201) {
          prescriptionMedicineIdController.clear();
          prescriptionIdController.clear();
          quantityController.clear();
        } else {
          throw Exception(
              'HTTP ${response1.statusCode} error: ${response1.body}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }

      return Future.value(rxListPrescription);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
