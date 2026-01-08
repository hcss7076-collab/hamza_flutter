import 'package:flutter/material.dart';
import '../widgets/store_item.dart'; // استيراد عنصر المتجر

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'المتاجر',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const StoreItem(
            name: 'بقالة النخيل',
            location: 'صنعاء - شارع الستين',
            rating: 4.5,
          ),
          const StoreItem(
            name: 'بقالة محمد سنان',
            location: 'اب - دار الشرف',
            rating: 4.2,
          ),
          const StoreItem(
            name: 'بقالة اليمن السعيد',
            location: 'عدن - منطقة الروضة',
            rating: 4.2,
          ),
          const StoreItem(
            name: 'بقالة السلام',
            location: 'تعز - شارع جمال',
            rating: 4.7,
          ),
          const StoreItem(
            name: 'بقالة الواحة',
            location: 'حضرموت - المكلا',
            rating: 4.0,
          ),
        ],
      ),
    );
  }
}
