import 'package:admin_dashboard/services/local_storage.dart';
import 'package:dio/dio.dart';

class CafeApi {
  static Dio _dio = new Dio();

  static void configureDio() {
    _dio.options.baseUrl = 'http://localhost:8080/api';

    // Configurar Headers más específicos para coincidir con Postman
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-token': LocalStorage.prefs.getString('token') ?? '',
    };

    // Configurar timeout
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }

  static Future httpGet(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print('Error en httpGet: $e');
      throw ('Error en el GET');
    }
  }

  static Future httpPost(String path, Map<String, dynamic> data) async {
    try {
      print('🔧 Headers: ${_dio.options.headers}');
      print('🔧 BaseURL: ${_dio.options.baseUrl}');
      print('🔧 Full URL: ${_dio.options.baseUrl}$path');

      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      print('Error en httpPost: $e');
      if (e is DioException) {
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
      }
      throw ('Error en el POST');
    }
  }
}
