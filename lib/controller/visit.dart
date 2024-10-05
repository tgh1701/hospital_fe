import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/visit.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class VisitController extends GetxController{
  RxList<Visit> rxListVisit = <Visit>[].obs;

  final TextEditingController visitIdController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  Future<RxList<Visit>> getVisit() async {
    try {
      final response = await HttpService.getRequest(apiVisit, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListVisit.value =
              result.map((item) => Visit.fromJson(item)).toList();
          AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListVisit);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Visit>> postVisit(String patient, String doctor, String disease, String dateIn, String dateOut) async {
    try {
      final data = {
        "visitId": visitIdController.text.trim(),
        "patientId": patient,
        "doctorId": doctor,
        "diseaseId": disease,
        "dateIn": dateIn,
        "dateOut": dateOut,
        "totalPrice": int.tryParse(totalPriceController.text.trim()) ?? 0,
        "status": statusController.text.trim(),
      };

      final response = await HttpService.postRequest(apiVisit, data, timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getVisit();
        _clearControllers();

      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListVisit);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  void _clearControllers() {
    visitIdController.clear();
    totalPriceController.clear();
    statusController.clear();
  }

  Future<RxList<Visit>> deleteVisit(String id) async {
    try {
      final response = await HttpService.deleteRequest('$apiVisit/$id', timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getVisit();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListVisit);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}