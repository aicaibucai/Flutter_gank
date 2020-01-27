import 'package:dio/dio.dart';

import 'entity/BaseEntity.dart';
import 'entity/TodayEntity.dart';

class ApiManage {
  static ApiManage _instance;

  factory ApiManage() => _getInstance();

  static ApiManage get instance => _getInstance();

  var BaseUrl = "http://gank.io/api/";

  static const _CONNECT_TIME_OUT = 5 * 1000;

  Dio _dio;
  BaseOptions _baseOptions;

  ApiManage._init() {
    _baseOptions = BaseOptions(
      baseUrl: BaseUrl,
      receiveTimeout: _CONNECT_TIME_OUT,
      connectTimeout: _CONNECT_TIME_OUT,
    );
    _dio = Dio(_baseOptions);
  }

  static ApiManage _getInstance() {
    if (_instance == null) {
      _instance = new ApiManage._init();
    }
    return _instance;
  }

  Future<BaseEntity<Map<String, List<TodayEntity>>>> getToday() async {
    return await _dio.get<Map<String, dynamic>>("today").then((value) {
      return BaseEntity<Map<String, List<TodayEntity>>>.fromJson(value.data);
    });
  }

  Future<BaseEntity<Map<String, List<TodayEntity>>>> getDate(
      String year, String month, String day) async {
    return await _dio
        .get<Map<String, dynamic>>("day/${year}/${month}/${day}")
        .then((value) {
      return BaseEntity<Map<String, List<TodayEntity>>>.fromJson(value.data);
    });
  }

  Future<BaseEntity<List<TodayEntity>>> getCategoryContent(
      String category, int size, int pagenum) async {
    return await _dio
        .get<Map<String, dynamic>>("data/${category}/${size}/${pagenum}")
        .then((value) {
      return BaseEntity<List<TodayEntity>>.fromJson(value.data);
    });
  }
}
