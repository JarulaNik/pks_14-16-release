import 'package:pks_3/model/product.dart';
import 'package:uuid/uuid.dart';

class Order {
  final int? orderId;
  final String userId;
  final DateTime orderDate;
  final double totalAmount;
  final List<OrderItem> items;

  Order({
    this.orderId,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['ID'],
      userId: json['UserID'],
      orderDate: DateTime.parse(json['OrderDate']),
      totalAmount: json['TotalAmount'].toDouble(),
      items: (json['Items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          ?.toList() ??
          [], // Обработка null для Items
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'order_date': orderDate.toIso8601String(),
    'total_amount': totalAmount,
    'items': items.map((item) => item.toJson()).toList(),
  };

  Order copyWith({
    int? orderId,
    String? userId,
    DateTime? orderDate,
    double? totalAmount,
    List<OrderItem>? items,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
    );
  }
}

class OrderItem {
  final int? id;
  final int orderID;
  final int productId;
  final int quantity;
  final double price;
  final String productName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  OrderItem({
    this.id,
    required this.orderID,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['ID'],
      orderID: json['OrderID'],
      productId: json['ProductID'],
      quantity: json['Quantity'],
      price: json['Price'].toDouble(),
      productName: json['ProductName'],
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']) : null,
      deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
    'price': price,
    'product_name': productName,
  };
}
class OrderResponse {
  final Order order;
  final int? orderId; // orderId can be null

  OrderResponse(this.order, this.orderId);
}