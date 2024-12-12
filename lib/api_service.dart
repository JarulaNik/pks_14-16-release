import 'package:dio/dio.dart';
import '/model/product.dart';
import 'model/order.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.56.1:8080', // Или ваш IP-адрес
    connectTimeout: 50000, // Duration для таймаута
    receiveTimeout: 50000,
  ));

  Future<List<Bearing>> getBearings() async {
    try {
      final response = await _dio.get('/bearings');
      if (response.statusCode == 200) {
        return (response.data as List).map((bearing) => Bearing.fromJson(bearing)).toList();
      } else {
        throw Exception('Ошибка при получении подшипников: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw _handleError(e, 'Ошибка при получении подшипников');
    }
  }

  Future<Bearing> createBearing(Bearing bearing) async {
    try {
      final response = await _dio.post('/bearings/create', data: bearing.toJson());
      if (response.statusCode == 201) {
        return Bearing.fromJson(response.data);
      } else {
        throw Exception('Ошибка при создании подшипника: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw _handleError(e, 'Ошибка при создании подшипника');
    }
  }

  Future<Bearing?> getBearingById(int id) async {
    try {
      final response = await _dio.get('/bearings/$id');
      if (response.statusCode == 200) {
        return Bearing.fromJson(response.data);
      } else {
        throw Exception('Ошибка при получении подшипника: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      _handleError(e, 'Ошибка при получении подшипника');
      return null;
    }
  }

  Future<Bearing?> updateBearing(int id, Bearing bearing) async {
    try {
      final response = await _dio.put('/bearings/update/$id', data: bearing.toJson());
      if (response.statusCode == 200) {
        return Bearing.fromJson(response.data);
      } else {
        throw Exception('Ошибка при обновлении подшипника: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      _handleError(e, 'Ошибка при обновлении подшипника');
      return null;
    }
  }

  Future<void> deleteBearing(int id) async {
    try {
      final response = await _dio.delete('/bearings/delete/$id');
      if (response.statusCode != 204 && response.statusCode != 200) { // 200 or 204 is OK
        throw Exception('Ошибка при удалении подшипника: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw _handleError(e, 'Ошибка при удалении подшипника');
    }
  }

  Future<OrderResponse> createOrder(Order order) async { // Изменено на OrderResponse
    try {
      final response = await _dio.post('/order/${order.userId}', data: order.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = response.data;
        if(jsonData == null){
          throw Exception('Сервер вернул пустой ответ');
        }
        final orderId = jsonData['id'] ?? 0; // извлечь ID из ответа сервера.
        return OrderResponse(Order.fromJson(jsonData), orderId); //Возвращаем OrderResponse
      } else {
        throw Exception('Ошибка при создании заказа: ${response.statusCode} - ${response.statusMessage} - ${response.data}');
      }
    } on DioError catch (e) {
      throw Exception('Ошибка при создании заказа (Dio): ${e.message} - ${e.response?.statusCode} - ${e.response?.data}');
    }
  }

  Future<List<Order>> getOrders(String userId) async { // userId теперь String
    try {
      final response = await _dio.get('/order/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> orderData = response.data; // Добавлено для обработки данных
        return orderData.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Ошибка при получении заказов: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw _handleError(e, 'Ошибка при получении заказов');
    }
  }


  Exception _handleError(DioError e, String message) {
    if (e.response != null) {
      return Exception('$message: ${e.response?.statusCode} - ${e.response?.data}');
    } else if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      return Exception('$message: Таймаут соединения');
    } else if (e.error != null) {
      return Exception('$message: ${e.error}');
    } else {
      return Exception('$message: Неизвестная ошибка');
    }
  }
}