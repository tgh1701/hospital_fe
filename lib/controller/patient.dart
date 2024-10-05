import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/patient.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class PatientController extends GetxController {
  RxList<Patient> rxListPatient = <Patient>[].obs;

  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<RxList<Patient>> getPatient() async {
    try {
      final response = await HttpService.getRequest(apiPatient, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListPatient.value =
              result.map((item) => Patient.fromJson(item)).toList();
          // AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListPatient);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Patient>> putPatient(Patient patient) async {
    try {
      final response = await HttpService.putRequest(
          '$apiPatient/${patient.patientId}', patient.toJson(),
          timeout: 30);

      if (response.statusCode == 200) {
        getPatient();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListPatient);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Patient>> postPatient() async {
    try {
      final data = Patient(
        patientId: patientIdController.text,
        identityCard: identityCardController.text,
        patientName: patientNameController.text,
        dateOfBirth: dateOfBirthController.text,
        address: addressController.text,
        phone: phoneController.text,
      );

      final response =
          await HttpService.postRequest(apiPatient, data.toJson(), timeout: 30);

      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getPatient();
        patientIdController.clear();
        identityCardController.clear();
        patientNameController.clear();
        dateOfBirthController.clear();
        addressController.clear();
        phoneController.clear();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListPatient);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }

  Future<RxList<Patient>> deletePatient(String id) async {
    try {
      final response =
          await HttpService.deleteRequest('$apiPatient/$id', timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        getPatient();
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListPatient);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
