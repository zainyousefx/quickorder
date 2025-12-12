import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../binding/local_preferences.dart';
import '../constants/constants.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio _dio;
  LocalPreferences localPreferences = Get.find();

  factory DioSingleton() {
    return _instance;
  }

  DioSingleton._internal() {
    // Initialize Dio with your preferred configurations
    _dio = Dio(BaseOptions(
        baseUrl: API,
        connectTimeout: Duration(seconds: 30),
    ));

    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        request: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 120));
  }

  Dio get dioInstance => _dio;
}
