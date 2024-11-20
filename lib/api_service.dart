import 'package:dio/dio.dart';
import '/model/product.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.56.1:8080', //Или ваш IP-адрес
    connectTimeout: 50000,
    receiveTimeout: 50000,
  ));

  Future<List<Bearing>> getBearings() async {
    try {
      final response = await _dio.get('/bearings');
      return _handleBearingResponse(response);
    } on DioError catch (e) {
      return _handleError(e, 'Ошибка при получении подшипников');
    }
  }

  Future<Bearing> createBearing(Bearing bearing) async {
    try {
      final response = await _dio.post('/bearings/create', data: bearing.toJson()); //Исправленный путь
      return _handleSingleBearingResponse(response);
    } on DioError catch (e) {
      return _handleError(e, 'Ошибка при создании подшипника');
    }
  }

  Future<Bearing?> getBearingById(int id) async { //Возвращаем Bearing? на случай ошибки
    try {
      final response = await _dio.get('/bearings/$id'); //Исправленный путь
      return _handleSingleBearingResponse(response);
    } on DioError catch (e) {
      _handleError(e, 'Ошибка при получении подшипника');
      return null; //Возвращаем null при ошибке
    }
  }

  Future<Bearing?> updateBearing(int id, Bearing bearing) async { //Bearing?
    try {
      final response = await _dio.put('/bearings/update/$id', data: bearing.toJson()); //Исправленный путь
      return _handleSingleBearingResponse(response);
    } on DioError catch (e) {
      _handleError(e, 'Ошибка при обновлении подшипника');
      return null;
    }
  }

  Future<bool> deleteBearing(int id) async { //Возвращаем bool - успех/неудача
    try {
      final response = await _dio.delete('/bearings/delete/$id'); //Исправленный путь
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Ошибка при удалении подшипника: ${response.statusCode} - ${response.data}');
      }
    } on DioError catch (e) {
      _handleError(e, 'Ошибка при удалении подшипника');
      return false;
    }
  }

  List<Bearing> _handleBearingResponse(Response response) {
    if (response.statusCode == 200) {
      return (response.data as List).map((bearing) => Bearing.fromJson(bearing)).toList();
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.data}');
    }
  }

  Bearing _handleSingleBearingResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) { //Добавлен 201 для create
      return Bearing.fromJson(response.data);
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.data}');
    }
  }

  //Функция для централизованной обработки ошибок Dio
  T _handleError<T>(DioError e, String message) {
    String errorMessage;
    if (e.response != null) {
      errorMessage = '$message: ${e.response?.statusCode} - ${e.response?.data}';
    } else if (e.error != null) {
      errorMessage = '$message: ${e.error}';
    } else {
      errorMessage = '$message: Неизвестная ошибка';
    }
    print(errorMessage);
    throw Exception(errorMessage);

  }
}