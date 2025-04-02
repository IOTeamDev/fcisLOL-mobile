import 'package:dio/dio.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';

class SendGridHelper {
  static Dio? dio;

  static initial() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.sendGridBaseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
      ),
    );
  }

  static Future post({required String endPoint, Object? data}) async {
    dio!.options.headers['Authorization'] = AppConstants.sendGridApiKey;
    dio!.options.headers['Content-Type'] = KeysManager.applicationJson;

    return await dio!.post(endPoint, data: data);
  }
}
