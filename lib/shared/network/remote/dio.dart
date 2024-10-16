import 'package:dio/dio.dart';

class DioHelp {
  // static var dio = Dio();
  static Dio? dio;

  static initial() {
    dio = Dio(
      BaseOptions(
          baseUrl: "https://fcislol.netlify.app/api/",
          receiveDataWhenStatusError: true,
          // headers: {"Content-Type": "application/json"}
          
          ),
    );
  }

  static Future<Response> getData({
    query,
    required path,
    lang = 'en',
    token,
  }) async {
    // if (dio == null) await initial();
    //async and await

    dio!.options.headers = {'lang': lang, 'Authorization': token??"",'Content-Type': "application/json"};
    return await dio!.get(path, queryParameters:query );
  }
  static Future<Response> putData({
    required Map<String, dynamic> query,
    required String path,
    lang = 'en',
    String? token,
    required Map<String, dynamic> data

  }) async {
    // if (dio == null) await initial();
    //async and await

    dio!.options.headers = {'lang': lang, 'Authorization': token??"",'Content-Type': 'application/json'};
    return await dio!.put(path, queryParameters:query ,data: data);
  }

  static Future<Response> postData({
    required String path,
    required data,
    lang = 'en',
    token,
    
  }) async {
    // if (dio == null) await initial();
    //async and await

    dio!.options.headers = {'lang': lang, 'Authorization': token,'Content-Type': "application/json"};
    return await dio!.post(path, data: data);

    
  }

  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,// Keep this as query params
    lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      if (token != null) 'Authorization': token,
    };
    return await dio!.delete(path,queryParameters: query, data: data);  // ID as query parameter
  }

}
