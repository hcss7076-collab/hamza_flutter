import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/app_provider.dart';
import '../models/order_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return appProvider.cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  Future<void> _updateQuantity(int index, int newQuantity) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    if (newQuantity <= 0) {
      await appProvider.removeFromCart(appProvider.cartItems[index].product.id);
    } else {
      await appProvider.updateCartItemQuantity(
        appProvider.cartItems[index].product.id,
        newQuantity,
      );
    }
  }

  Future<void> _removeItem(int index) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.removeFromCart(appProvider.cartItems[index].product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final cartItems = appProvider.cartItems;

          return cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'سلة التسوق فارغة',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child:
                                          item.product.imageUrl.startsWith(
                                            'http',
                                          )
                                          ? Image.network(
                                              item.product.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            )
                                          : (item.product.imageUrl.startsWith(
                                                  'images/',
                                                ) ||
                                                item.product.imageUrl
                                                    .startsWith('assets/'))
                                          ? Image.asset(
                                              item.product.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(item.product.imageUrl),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${item.product.price.toStringAsFixed(0)} ريال',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async =>
                                            await _updateQuantity(
                                              index,
                                              item.quantity - 1,
                                            ),
                                        icon: const Icon(Icons.remove),
                                        color: Colors.red,
                                      ),
                                      Text(
                                        item.quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _updateQuantity(
                                          index,
                                          item.quantity + 1,
                                        ),
                                        icon: const Icon(Icons.add),
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () async =>
                                        await _removeItem(index),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Consumer<AppProvider>(
                            builder: (context, appProvider, child) {
                              final total = appProvider.cartItems.fold<double>(
                                0.0,
                                (sum, item) =>
                                    sum + (item.product.price * item.quantity),
                              );
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'المجموع الكلي:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${total.toStringAsFixed(0)} ريال',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: cartItems.isNotEmpty
                                  ? () async {
                                      // منطق إتمام الطلب
                                      final total = appProvider.cartItems
                                          .fold<double>(
                                            0.0,
                                            (sum, item) =>
                                                sum +
                                                (item.product.price *
                                                    item.quantity),
                                          );

                                      final order = Order(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        customerName:
                                            'عميل نقدي', // يمكن تخصيصه لاحقاً
                                        customerPhone: '0000000000',
                                        items: cartItems,
                                        totalAmount: total,
                                        status: OrderStatus.confirmed,
                                      );

                                      final success = await appProvider
                                          .addOrder(order);

                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'تم إرسال الطلب بنجاح!',
                                            ),
                                          ),
                                        );
                                        await appProvider.clearCart();
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'فشل في إتمام الطلب!',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'إتمام الطلب',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
