import 'package:dio/dio.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';

class DioHelp {
  static Dio? dio;

  static initial() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.appBaseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    query,
    required path,
    lang = 'en',
    token,
  }) async {
    dio!.options.headers = {
      KeysManager.lang: lang,
      KeysManager.authorization: token ?? "",
      KeysManager.contentType: KeysManager.applicationJson
    };
    return await dio!.get(path, queryParameters: query);
  }

  static Future<Response> postData({
    required String path,
    required data,
    lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      KeysManager.lang: lang,
      KeysManager.authorization: token,
      KeysManager.contentType: KeysManager.applicationJson
    };
    return await dio!.post(path, data: data);
  }

  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data, // Keep this as query params
    lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      if (token != null) 'Authorization': token,
    };
    return await dio!.delete(path,
        queryParameters: query, data: data); // ID as query parameter
  }

  static Future<Response> putData(
      {required Map<String, dynamic> query,
      required String path,
      lang = 'en',
      String? token,
      required Map<String, dynamic> data}) async {
    dio!.options.headers = {
      KeysManager.lang: lang,
      KeysManager.authorization: token ?? "",
      KeysManager.contentType: KeysManager.applicationJson
    };
    return await dio!.put(path, queryParameters: query, data: data);
  }

  static Future<Response> patchData({
    required String path,
    required Map<String, dynamic> data,
    lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      KeysManager.lang: lang,
      KeysManager.authorization: token,
      KeysManager.contentType: KeysManager.applicationJson
    };
    return await dio!.patch(path, data: data);
  }
}
