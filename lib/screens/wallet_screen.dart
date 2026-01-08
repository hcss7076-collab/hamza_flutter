// // screens/wallet_screen.dart
// import 'package:flutter/material.dart';
// import '../widgets/wallet_widgets.dart'; // استيراد العناصر المساعدة

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'المحفظة الإلكترونية',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           // كارت الرصيد الرئيسي
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   const Text(
//                     'رصيدك الحالي',
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     '25,000 ريال يمني',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       WalletActionButton(
//                         icon: Icons.add,
//                         label: 'شحن',
//                         color: Colors.green,
//                         onPressed: () => debugPrint('شحن'),
//                       ),
//                       WalletActionButton(
//                         icon: Icons.arrow_upward,
//                         label: 'إرسال',
//                         color: Colors.blue,
//                         onPressed: () => debugPrint('إرسال'),
//                       ),
//                       WalletActionButton(
//                         icon: Icons.history,
//                         label: 'سجل',
//                         color: Colors.orange,
//                         onPressed: () => debugPrint('سجل'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'طرق الدفع المتاحة',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           // طرق الدفع
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 3,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             children: const [
//               PaymentMethodCard(name: 'الراجحي', icon: Icons.account_balance),
//               PaymentMethodCard(
//                 name: 'الكاش يمني',
//                 icon: Icons.mobile_friendly,
//               ),
//               PaymentMethodCard(name: 'سداد', icon: Icons.payment),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
