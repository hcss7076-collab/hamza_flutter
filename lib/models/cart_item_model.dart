import 'product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  // Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  // Convert CartItem to Map for storage
  Map<String, dynamic> toMap() {
    return {'product': product.toMap(), 'quantity': quantity};
  }

  // Create CartItem from Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] ?? {}),
      quantity: map['quantity'] ?? 1,
    );
  }

  // Create a copy with updated quantity
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Check if can increase quantity (based on available stock)
  bool canIncreaseQuantity() {
    return quantity < product.quantity;
  }

  // Check if can decrease quantity
  bool canDecreaseQuantity() {
    return quantity > 1;
  }

  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, total: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;
}
