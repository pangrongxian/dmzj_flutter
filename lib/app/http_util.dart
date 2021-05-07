import 'package:dio/dio.dart';

class HttpUtil {
  static HttpUtil? _httpUtil;
  static HttpUtil get instance {
    if (_httpUtil == null) {
      _httpUtil = HttpUtil();
    }
    return _httpUtil!;
  }

  late Dio dio;
  HttpUtil() {
    dio = Dio(
      BaseOptions(),
    );
  }
  Future<String> httpGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool needLogin = false,
  }) async {
    try {
      var result = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      return result.data;
    } catch (e) {
      if (e is DioError) {
        dioErrorHandle(e);
      } else {
        throw AppError("网络请求失败");
      }
      return "";
    }
  }

  Future<dynamic> httpGetJson(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool needLogin = false,
  }) async {
    try {
      var result = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return result.data;
    } catch (e) {
      if (e is DioError) {
        dioErrorHandle(e);
      } else {
        throw AppError("网络请求失败");
      }
      return {};
    }
  }

  void dioErrorHandle(DioError e) {
    switch (e.type) {
      case DioErrorType.cancel:
        throw AppError("请求被取消");
      case DioErrorType.response:
        throw AppError("请求失败:${e.response!.statusCode}");
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw AppError("网络连接超时,请稍后再试");
      default:
        throw AppError("请求失败,无法连接至服务器");
    }
  }
}

class AppError implements Exception {
  final int? code;
  final String message;
  AppError(
    this.message, {
    this.code,
  });

  @override
  String toString() {
    return message;
  }
}
