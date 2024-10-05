import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/controller/visit.dart';
import 'package:hospital_fe/model/care.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class CareController extends GetxController {
  RxList<Care> rxListCare = <Care>[].obs;

  final VisitController visitController = Get.put(VisitController());

  final TextEditingController careIdController = TextEditingController();

  Future<RxList<Care>> postCare(String visitId, String nurseId, String date) async {
    try {
      final data = Care(careId: careIdController.text, visitId: visitId, nurseId: nurseId, dateCare: date);
      final response =
          await HttpService.postRequest(apiCare, data.toJson(), timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        visitController.getVisit();
        careIdController.clear();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListCare);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
