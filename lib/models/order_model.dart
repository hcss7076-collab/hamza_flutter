import 'dart:convert';
import 'cart_item_model.dart';

enum OrderStatus {
  pending('في الانتظار'),
  confirmed('مؤكد'),
  preparing('قيد التحضير'),
  ready('جاهز'),
  delivered('تم التسليم'),
  cancelled('ملغي');

  const OrderStatus(this.displayName);
  final String displayName;
}

class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.totalAmount,
    required this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert Order to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'items': jsonEncode(items.map((item) => item.toMap()).toList()),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  // Create Order from Map
  factory Order.fromMap(Map<String, dynamic> map) {
    List<CartItem> items = [];
    if (map['items'] != null) {
      try {
        final itemsJson = jsonDecode(map['items'] as String) as List<dynamic>;
        items = itemsJson.map((item) => CartItem.fromMap(item)).toList();
      } catch (e) {
        // If decoding fails, use empty list
        items = [];
      }
    }

    return Order(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      items: items,
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      notes: map['notes'],
    );
  }

  // Create a copy with updated fields
  Order copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  // Get formatted total amount
  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  // Get items count
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  // Check if order can be cancelled
  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  // Check if order is completed
  bool get isCompleted => status == OrderStatus.delivered;

  // Check if order is active
  bool get isActive =>
      status == OrderStatus.pending ||
      status == OrderStatus.confirmed ||
      status == OrderStatus.preparing ||
      status == OrderStatus.ready;

  @override
  String toString() {
    return 'Order(id: $id, customer: $customerName, total: $totalAmount, status: ${status.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
