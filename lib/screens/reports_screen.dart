import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        double totalSales = appProvider.orders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        );
        int totalProducts = appProvider.products.length;
        int totalQuantity = appProvider.products.fold(
          0,
          (sum, product) => sum + product.quantity,
        );
        int totalNotes = appProvider.notes.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('التقارير'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقارير المخزن',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // إحصائيات عامة
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الإحصائيات العامة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              'إجمالي المبيعات',
                              '${totalSales.toStringAsFixed(0)} ريال',
                              Colors.orange,
                            ),
                            _buildStatCard(
                              'عدد المنتجات',
                              '$totalProducts',
                              Colors.green,
                            ),
                            _buildStatCard(
                              'الكمية الكلية',
                              '$totalQuantity',
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // تقرير المبيعات
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تقرير المبيعات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        appProvider.orders.isEmpty
                            ? const Text('لا توجد مبيعات مسجلة')
                            : Column(
                                children: appProvider.orders.map((order) {
                                  final productNames = order.items
                                      .map((item) => item.product.name)
                                      .join(', ');
                                  return ListTile(
                                    title: Text(productNames),
                                    subtitle: Text(
                                      'التاريخ: ${order.createdAt.toString().split(' ')[0]} | المجموع: ${order.totalAmount.toStringAsFixed(0)} ريال',
                                    ),
                                    trailing: Text(
                                      '${order.totalAmount.toStringAsFixed(0)} ريال',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // تقرير المنتجات
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تقرير المنتجات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        appProvider.products.isEmpty
                            ? const Text('لا توجد منتجات')
                            : Column(
                                children: appProvider.products.map((product) {
                                  return ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(
                                      'السعر: ${product.price.toStringAsFixed(0)} ريال | الكمية: ${product.quantity}',
                                    ),
                                    trailing: Icon(
                                      product.quantity > 0
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: product.quantity > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // تقرير الملاحظات
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تقرير الملاحظات (${totalNotes})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        appProvider.notes.isEmpty
                            ? const Text('لا توجد ملاحظات')
                            : Column(
                                children: appProvider.notes.map((note) {
                                  return ListTile(
                                    title: Text(note.title),
                                    subtitle: Text(
                                      '${note.content} - ${note.createdAt.toString().split(' ')[0]}',
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
