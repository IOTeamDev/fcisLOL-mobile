import 'package:dio/dio.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/presentation/auth_constants/auth_strings.dart';

abstract class DioExceptionHandler {
  static String getMessage({
    required DioException e,
    String? badResponseMessage,
  }) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "The connection took too long. Please check your internet and try again.";
      case DioExceptionType.sendTimeout:
        return "Unable to send data to the server. Please try again.";
      case DioExceptionType.receiveTimeout:
        return "The server is taking too long to respond. Try again later.";
      case DioExceptionType.badCertificate:
        return "Secure connection failed. Please check your network.";
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 400)
          return badResponseMessage ?? "Invalid request. Please try again.";
        if (status == 401)
          return "You are not authorized. Please log in again.";
        if (status == 403) return "Access denied. You don’t have permission.";
        if (status == 404) return "We couldn’t find what you’re looking for.";
        return AppStrings.unknownErrorMessage;
      case DioExceptionType.cancel:
        return "The request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.unknown:
        return "Something went wrong. Please try again.";
    }
  }
}
