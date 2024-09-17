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
    query,
    required path,
    lang = 'en',
    token,
    required data

  }) async {
    // if (dio == null) await initial();
    //async and await

    dio!.options.headers = {'lang': lang, 'Authorization': token??"",'Content-Type': "application/json"};
    return await dio!.put(path, queryParameters:query??null ,data: data);
  }

  static Future<Response> postData({
    required path,
    required data,
    lang = 'en',
    token,
    
  }) async {
    // if (dio == null) await initial();
    //async and await

    dio!.options.headers = {'lang': lang, 'Authorization': token,'Content-Type': "application/json"};
    return await dio!.post(path, data: data);

    
  }


}
