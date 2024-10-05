import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/nurse.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class NurseController extends GetxController {
  RxList<Nurse> rxListNurse = <Nurse>[].obs;

  final TextEditingController nurseIdController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();
  final TextEditingController nurseNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController seniorityController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<RxList<Nurse>> getNurse() async {
    try {
      final response = await HttpService.getRequest(apiNurse, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListNurse.value =
              result.map((item) => Nurse.fromJson(item)).toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListNurse);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Nurse>> putNurse(Nurse nurse) async {
    try {
      final response =
      await HttpService.putRequest('$apiNurse/${nurse.nurseId}', nurse.toJson(), timeout: 30);

      if (response.statusCode == 200) {
        getNurse();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListNurse);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Nurse>> postNurse() async {
    try {
      final data = Nurse(
        nurseId: nurseIdController.text,
        identityCard: identityCardController.text,
        nurseName: nurseNameController.text,
        level: levelController.text,
        seniority: int.parse(seniorityController.text),
        dateOfBirth: dateOfBirthController.text,
        address: addressController.text,
        phone: phoneController.text,
      );

      final response =
          await HttpService.postRequest(apiNurse, data.toJson(), timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getNurse();
        nurseIdController.clear();
        identityCardController.clear();
        nurseNameController.clear();
        dateOfBirthController.clear();
        addressController.clear();
        seniorityController.clear();
        levelController.clear();
        phoneController.clear();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListNurse);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Nurse>> deleteNurse(String id) async {
    try {
      final response =
          await HttpService.deleteRequest('$apiNurse/$id', timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getNurse();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListNurse);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
