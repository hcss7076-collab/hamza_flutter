// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   final String name;
//   final String email;

//   const ProfileScreen({
//     super.key,
//     required this.name,
//     required this.email,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SizedBox(height: 16),

//           // صورة الملف الشخصي
//           const CircleAvatar(
//             radius: 50,
//             backgroundImage: NetworkImage('https://placehold.co/150'),
//             backgroundColor: Colors.grey,
//           ),

//           const SizedBox(height: 16),

//           // الاسم القادم من تسجيل الدخول
//           Text(
//             name,
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),

//           // المهنة (ثابتة)
//           const Text(
//             'تاجر مواد غذائية',
//             style: TextStyle(color: Colors.grey),
//           ),

//           // البريد الإلكتروني القادم من تسجيل الدخول
//           Text(
//             email,
//             style: const TextStyle(color: Colors.grey),
//           ),

//           const SizedBox(height: 16),

//           // كارت معلومات التواصل
//           Card(
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'معلومات التواصل',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 16),

//                   ListTile(
//                     leading: const Icon(Icons.phone, color: Colors.green),
//                     title: const Text('+967773616787'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.copy),
//                       onPressed: () =>
//                           debugPrint('Copy phone number pressed'),
//                     ),
//                   ),

//                   // البريد الإلكتروني (ديناميكي)
//                   ListTile(
//                     leading: const Icon(Icons.email, color: Colors.green),
//                     title: Text(email),
//                   ),

//                   const ListTile(
//                     leading:
//                         Icon(Icons.location_on, color: Colors.green),
//                     title: Text(' اليمن'),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // كارت الإعدادات والدعم
//           Card(
//             elevation: 2,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.settings,
//                       color: Colors.blueGrey),
//                   title: const Text('الإعدادات'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () => debugPrint('Settings tapped'),
//                 ),

//                 const Divider(height: 1),

//                 ListTile(
//                   leading:
//                       const Icon(Icons.help, color: Colors.blueGrey),
//                   title: const Text('مساعدة'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () => debugPrint('Help tapped'),
//                 ),

//                 const Divider(height: 1),

//                 ListTile(
//                   leading: const Icon(Icons.logout, color: Colors.red),
//                   title: const Text(
//                     'تسجيل الخروج',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onTap: () => debugPrint('Logout tapped'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'settingspage.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;

  const ProfileScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // صورة الملف الشخصي
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: appProvider.profilePicturePath != null
                    ? FileImage(File(appProvider.profilePicturePath!))
                    : null,
                child: appProvider.profilePicturePath == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'تاجر مواد غذائية',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // كارت معلومات التواصل
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'معلومات التواصل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.green),
                        title: const Text('+967773616787'),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              debugPrint('Copy phone number pressed'),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.green),
                        title: Text(email),
                      ),
                      const ListTile(
                        leading: Icon(Icons.location_on, color: Colors.green),
                        title: Text(' اليمن'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // كارت الإعدادات والدعم
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('الإعدادات'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.help, color: Colors.blueGrey),
                      title: const Text('مساعدة'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => debugPrint('Help tapped'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () => debugPrint('Logout tapped'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
