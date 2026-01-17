import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'providers/app_provider.dart';
import 'translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.initialize();
  runApp(EliteWarehouse(appProvider: appProvider));
}

class EliteWarehouse extends StatelessWidget {
  final AppProvider appProvider;

  const EliteWarehouse({super.key, required this.appProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => appProvider,
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'مخزن النخبة',
            translations: AppTranslations(),
            locale: const Locale('ar', 'SA'),
            fallbackLocale: const Locale('ar', 'SA'),

            themeMode: provider.themeMode,

            theme: ThemeData(
              primarySwatch: Colors.green,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.green,
                accentColor: Colors.amber,
              ),
              fontFamily: 'Cairo', // Arabic-friendly font
              // Consistent design system
              cardTheme: const CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 4,
                iconTheme: IconThemeData(color: Colors.green),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                centerTitle: true,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                elevation: 8,
                backgroundColor: Colors.white,
                selectedLabelStyle: TextStyle(fontFamily: 'Cairo'),
                unselectedLabelStyle: TextStyle(fontFamily: 'Cairo'),
              ),
              // Arabic RTL Support
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
                headlineMedium: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
                headlineSmall: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
                titleMedium: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
                titleSmall: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(fontFamily: 'Cairo'),
                bodyMedium: TextStyle(fontFamily: 'Cairo'),
                bodySmall: TextStyle(fontFamily: 'Cairo'),
                labelLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                labelMedium: TextStyle(fontFamily: 'Cairo'),
                labelSmall: TextStyle(fontFamily: 'Cairo'),
              ),
            ),

            darkTheme: ThemeData(
              primarySwatch: Colors.green,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.green,
                accentColor: Colors.amber,
                brightness: Brightness.dark,
              ),
              fontFamily: 'Cairo', // Arabic-friendly font
              // Consistent design system
              cardTheme: const CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade800,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                elevation: 4,
                iconTheme: IconThemeData(color: Colors.green),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                centerTitle: true,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                elevation: 8,
                backgroundColor: Color(0xFF1E1E1E),
                selectedLabelStyle: TextStyle(fontFamily: 'Cairo'),
                unselectedLabelStyle: TextStyle(fontFamily: 'Cairo'),
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),
              // Arabic RTL Support
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                headlineMedium: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                headlineSmall: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                titleLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                titleMedium: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                titleSmall: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                bodyLarge: TextStyle(fontFamily: 'Cairo', color: Colors.white),
                bodyMedium: TextStyle(fontFamily: 'Cairo', color: Colors.white),
                bodySmall: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                ),
                labelLarge: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                labelMedium: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                ),
                labelSmall: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                ),
              ),
            ),

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

// SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "حمزه الشامي\nمخزن النخبة",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
