import 'package:dio/dio.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/core/utils/app_string.dart';

class DioApp {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppUrl.apilick,
        receiveDataWhenStatusError: true,
        headers: {
          "Authorization": "Bearer ${Stringconstants.token}",
          "Accept": "application/json"
        },
      ),
    );
  }

  static void updateAuthorizationToken(String newToken) {
    dio.options.headers['Authorization'] = 'Bearer $newToken';
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return dio.put(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postimg({
    required String url,
    required FormData data,
  }) async {
    return dio.post(
      url,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
  }) async {
    return dio.delete(
      url,
    );
  }
}
