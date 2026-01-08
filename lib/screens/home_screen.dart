// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';
import '../login.dart';
import 'home_summary_screen.dart';
import 'products_screen.dart';
import 'stores_screen.dart';
// import 'wallet_screen.dart';
import 'profile_screen.dart';
import 'add_product_screen.dart';
import 'cart_screen.dart';
import 'settingspage.dart';
import '../providers/app_provider.dart';
import '../models/product_model.dart';

// بيانات التطبيق (مؤقتًا)
class AppData {
  // static List<Map<String, dynamic>> products = [
  //   {
  //     'title': 'أرز يمني فاخر',
  //     'price': '2500 ريال',
  //     'imageUrl': 'images/rice.jpg',
  //     'quantity': 10,
  //   },
  //   {
  //     'title': 'زيت طعام',
  //     'price': '4200 ريال',
  //     'imageUrl': 'https://placehold.co/300/blue/white?text=زيت',
  //     'quantity': 5,
  //   },
  //   {
  //     'title': 'سكر أبيض',
  //     'price': '1800 ريال',
  //     'imageUrl': 'https://placehold.co/300/red/white?text=سكر',
  //     'quantity': 20,
  //   },
  // ];

  static List<Map<String, dynamic>> cart = [];
  static List<Map<String, dynamic>> sales = [];
  static List<Map<String, dynamic>> notes = [];
}

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;

  const HomeScreen({super.key, required this.name, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Initialize some sample data if the app is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSampleData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeSampleData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // Add sample products if none exist
    if (appProvider.products.isEmpty) {
      appProvider.setProducts([
        // Product(
        //   id: '1',
        //   name: 'أرز يمني فاخر',
        //   description: 'أرز يمني عالي الجودة',
        //   price: 2500,
        //   quantity: 10,
        //   category: 'حبوب',
        //   imageUrl: 'images/rice.jpg',
        // ),
        // Product(
        //   id: '2',
        //   name: 'زيت طعام',
        //   description: 'زيت طعام نقي 100%',
        //   price: 4200,
        //   quantity: 5,
        //   category: 'زيوت',
        //   imageUrl: 'images/oil.jpg',
        // ),
        // Product(
        //   id: '3',
        //   name: 'سكر أبيض',
        //   description: 'سكر أبيض نقي',
        //   price: 1800,
        //   quantity: 20,
        //   category: 'سكريات',
        //   imageUrl: 'images/sugar.jpg',
        // ),
      ]);
    }
  }

  // إضافة منتج جديد
  Future<bool> _addProduct(
    String name,
    String price,
    String description,
    String category,
    int quantity,
    String? imagePath,
  ) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: double.tryParse(price.replaceAll(' ريال', '')) ?? 0,
      quantity: quantity,
      category: category,
      imageUrl: imagePath ?? 'https://placehold.co/300/grey/white?text=جديد',
    );

    return await appProvider.addProduct(newProduct);
  }

  // الانتقال إلى تبويب معين
  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  // قائمة الصفحات
  List<Widget> _getPages() => [
    HomeSummaryScreen(
      name: widget.name,
      email: widget.email,
      onNavigateToProducts: () => _navigateToTab(1),
    ),
    const ProductsScreen(),
    StoresScreen(), // بدون const
    // WalletScreen(), // بدون const
    Consumer<AppProvider>(
      builder: (context, appProvider, child) => ProfileScreen(
        key: ValueKey(
          appProvider.profilePicturePath,
        ), // Force rebuild on profile picture change
        name: widget.name,
        email: widget.email,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مخزن النخبة'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // أيقونة السلة
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              final cartCount = appProvider.cartItems.length;
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (cartCount > 0)
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: appProvider.profilePicturePath != null
                            ? FileImage(File(appProvider.profilePicturePath!))
                            : null,
                        child: appProvider.profilePicturePath == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.green,
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Theme Mode Slider
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'وضع المظهر',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.light_mode, size: 20),
                          Expanded(
                            child: Slider(
                              value: appProvider.themeMode == ThemeMode.light
                                  ? 0
                                  : appProvider.themeMode == ThemeMode.system
                                  ? 1
                                  : 2,
                              min: 0,
                              max: 2,
                              divisions: 2,
                              onChanged: (value) {
                                ThemeMode newMode;
                                if (value == 0) {
                                  newMode = ThemeMode.light;
                                } else if (value == 1) {
                                  newMode = ThemeMode.system;
                                } else {
                                  newMode = ThemeMode.dark;
                                }
                                appProvider.setThemeMode(newMode);
                              },
                              activeColor: Colors.green,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          const Icon(Icons.dark_mode, size: 20),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('فاتح', style: TextStyle(fontSize: 12)),
                          Text('تلقائي', style: TextStyle(fontSize: 12)),
                          Text('داكن', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    // Navigate to settings screen
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('المساعدة'),
                  onTap: () {
                    // Navigate to help screen
                    Navigator.pop(context); // Close drawer
                    // Add navigation to help if available
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('حول التطبيق'),
                  // onTap: () {
                  //   // Show about dialog
                  //   Navigator.pop(context); // Close drawer
                  //   showAboutDialog(
                  //     context: context,
                  //     applicationName: 'مخزن النخبة',
                  //     applicationVersion: '1.0.0',
                  //     applicationLegalese: '© 2026 حمزه الشامي',
                  //   );
                  // },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('تسجيل الخروج'),
                  onTap: () {
                    // Logout logic
                    Navigator.pop(context); // Close drawer
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _getPages(),
      ),

      bottomNavigationBar: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return CurvedNavigationBar(
            index: _currentIndex,
            height: 60.0,
            items: const <Widget>[
              Icon(Icons.home, size: 30),
              Icon(Icons.inventory, size: 30),
              Icon(Icons.store, size: 30),
              Icon(Icons.person, size: 30),
            ],
            color: appProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            buttonBackgroundColor: Colors.green,
            backgroundColor: appProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF121212)
                : Colors.green.shade100,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            letIndexChange: (index) => true,
          );
        },
      ),

      // زر الإضافة العائم (فقط في صفحة المنتجات)
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );

                if (result != null && result is Map<String, dynamic>) {
                  final success = await _addProduct(
                    result['name'],
                    result['price'],
                    result['description'],
                    result['category'],
                    result['quantity'],
                    result['imagePath'],
                  );

                  if (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('فشل في إضافة المنتج')),
                    );
                  }
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
