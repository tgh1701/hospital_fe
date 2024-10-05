import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/doctor.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class DoctorController extends GetxController {
  RxList<Doctor> rxListDoctor = <Doctor>[].obs;

  final TextEditingController doctorIdController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController careerLevelController = TextEditingController();
  final TextEditingController seniorityController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  Future<RxList<Doctor>> getDoctor() async {
    try {
      final response = await HttpService.getRequest(apiDoctor, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListDoctor.value =
              result.map((item) => Doctor.fromJson(item)).toList();
          AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListDoctor);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Doctor>> putDoctor(Doctor doctor) async {
    try {
      final response =
          await HttpService.putRequest('$apiDoctor/${doctor.doctorId}', doctor.toJson(), timeout: 30);

      if (response.statusCode == 200) {
        getDoctor();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListDoctor);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Doctor>> postDoctor(String id) async {
    try {
      final data = Doctor(
        doctorId: doctorIdController.text,
        identityCard: identityCardController.text,
        doctorName: doctorNameController.text,
        dateOfBirth: dateOfBirthController.text,
        address: addressController.text,
        careerLevel: int.parse(careerLevelController.text),
        seniority: int.parse(seniorityController.text),
        level: levelController.text,
        departmentId: id,
      );

      final response =
          await HttpService.postRequest(apiDoctor, data.toJson(), timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getDoctor();
        doctorIdController.clear();
        identityCardController.clear();
        doctorNameController.clear();
        dateOfBirthController.clear();
        addressController.clear();
        careerLevelController.clear();
        seniorityController.clear();
        levelController.clear();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListDoctor);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Doctor>> deleteDoctor(String id) async {
    try {
      final response =
          await HttpService.deleteRequest("$apiDoctor/$id", timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getDoctor();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListDoctor);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
