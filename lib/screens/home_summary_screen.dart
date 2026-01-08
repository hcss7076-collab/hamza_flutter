import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import 'notes_screen.dart';
import 'sales_screen.dart';
import 'reports_screen.dart';
import 'account_screen.dart';
import 'profile_screen.dart';
import '../providers/app_provider.dart';

class HomeSummaryScreen extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onNavigateToProducts;

  const HomeSummaryScreen({
    super.key,
    required this.name,
    required this.email,
    required this.onNavigateToProducts,
  });

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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مرحباً بك في مخزن النخبة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

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

              // أزرار رئيسية
              const Text(
                'الأقسام الرئيسية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildNavigationButton(
                    context,
                    'حساب التاجر',
                    Icons.account_circle,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountScreen(name: name, email: email),
                      ),
                    ),
                  ),
                  _buildNavigationButton(
                    context,
                    'دفتر الملاحظات',
                    Icons.note,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotesScreen()),
                    ),
                  ),
                  // _buildNavigationButton(
                  //   context,
                  //   'المنتجات',
                  //   Icons.inventory,
                  //   Colors.green,
                  //   onNavigateToProducts,
                  // ),
                  _buildNavigationButton(
                    context,
                    'المبيعات',
                    Icons.shopping_cart,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SalesScreen()),
                    ),
                  ),
                  _buildNavigationButton(
                    context,
                    'التقارير',
                    Icons.bar_chart,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportsScreen()),
                    ),
                  ),
                  // _buildNavigationButton(
                  //   context,
                  //   'الإعدادات',
                  //   Icons.settings,
                  //   Colors.grey,
                  //   () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ProfileScreen(name: name, email: email),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
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
