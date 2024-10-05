import 'dart:convert';

import 'package:get/get.dart';
import 'package:hospital_fe/const/api_endpoint.dart';
import 'package:hospital_fe/model/disease.dart';
import 'package:hospital_fe/util/http.dart';
import 'package:hospital_fe/util/logger.dart';

class DiseaseController extends GetxController {
  RxList<Disease> rxListDisease = <Disease>[].obs;

  Future<RxList<Disease>> getDisease() async {
    try {
      final response = await HttpService.getRequest(apiDisease, timeout: 30);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse.containsKey('result')) {
          final List<dynamic> result = jsonResponse['result'];
          rxListDisease.value =
              result.map((item) => Disease.fromJson(item)).toList();
          AppLogger.debug(decodedBody);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} error: ${response.body}');
      }
      return Future.value(rxListDisease);
    } catch (e) {
      HttpService.handleHttpError(e);
      return Future.error(e);
    }
  }
}
