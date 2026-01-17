import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.setProfilePicture(image.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الصورة الشخصية')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل في اختيار الصورة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('settings'.tr),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Picture Section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'profile_picture'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    appProvider.profilePicturePath != null
                                    ? FileImage(
                                        File(appProvider.profilePicturePath!),
                                      )
                                    : null,
                                child: appProvider.profilePicturePath == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.photo_library),
                                label: Text('choose_image'.tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Theme Settings
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إعدادات المظهر',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('وضع المظهر'),
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
                          children: [
                            Text(
                              'light'.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'auto'.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'dark'.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Language Settings
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'language'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('العربية'),
                          trailing: Get.locale?.languageCode == 'ar'
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            Get.updateLocale(const Locale('ar', 'SA'));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('English'),
                          trailing: Get.locale?.languageCode == 'en'
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            Get.updateLocale(const Locale('en', 'US'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Info
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معلومات التطبيق',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const ListTile(
                          leading: Icon(Icons.info),
                          title: Text('الإصدار'),
                          subtitle: Text('1.0.0'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.person),
                          title: Text('المطور'),
                          subtitle: Text('حمزه الشامي'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.business),
                          title: Text('الشركة'),
                          subtitle: Text('مخزن النخبة'),
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
}
