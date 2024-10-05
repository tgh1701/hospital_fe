import 'dart:async';
import 'dart:convert';
import 'package:hospital_fe/util/logger.dart';
import 'package:http/http.dart' as http;

class HttpService {
  // GET request
  static Future<http.Response> getRequest(String url,
      {int timeout = 10}) async {
    final client = http.Client();
    try {
      return await client.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: timeout));
    } finally {
      client.close();
    }
  }

  // PUT request
  static Future<http.Response> putRequest(String url, Map<String, dynamic> data,
      {int timeout = 10}) async {
    final client = http.Client();
    try {
      AppLogger.info('Data: ${jsonEncode(data)}');
      return await client
          .put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      )
          .timeout(Duration(seconds: timeout));
    } finally {
      client.close();
    }
  }

  // POST request
  static Future<http.Response> postRequest(
      String url, Map<String, dynamic> data,
      {int timeout = 10}) async {
    final client = http.Client();
    try {
      AppLogger.info('Data: ${jsonEncode(data)}');
      return await client
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      )
          .timeout(Duration(seconds: timeout));
    } finally {
      client.close();
    }
  }

  // DELETE request
  static Future<http.Response> deleteRequest(String url,
      {int timeout = 10}) async {
    final client = http.Client();
    try {
      return await client.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: timeout));
    } finally {
      client.close();
    }
  }

  // PATCH request
  static Future<http.Response> patchRequest(
      String url, Map<String, dynamic> data,
      {int timeout = 10}) async {
    final client = http.Client();
    try {
      AppLogger.info('Data: ${jsonEncode(data)}');
      return await client
          .patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      )
          .timeout(Duration(seconds: timeout));
    } finally {
      client.close();
    }
  }

  // HTTP error
  static void handleHttpError(dynamic e) {
    if (e is http.ClientException) {
      AppLogger.error('ClientException: $e');
    } else if (e is TimeoutException) {
      AppLogger.error('Request timed out');
    } else {
      AppLogger.error('Error: $e');
    }
  }
}
