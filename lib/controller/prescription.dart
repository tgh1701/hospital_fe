import 'dart:convert';
import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/prescription.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class PrescriptionController extends GetxController {
  RxList<Prescription> rxListPrescription = <Prescription>[].obs;

  Future<RxList<Prescription>> getPrescription(String id) async {
    try {
      final response = await HttpService.getRequest('$apiPrescription/$id', timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListPrescription.value = result.map((item) => Prescription.fromJson(item)).toList();
          AppLogger.debug(decodedBody);
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
}
