import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'database/database_helper.dart';

// LoginPage
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يرجى ملء جميع الحقول")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dbHelper = DatabaseHelper();
      final user = await dbHelper.getUser(
        emailController.text.trim(),
        passController.text,
      );

      if (user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HomeScreen(name: user['name'], email: user['email']),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("بيانات الدخول غير صحيحة")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("حدث خطأ أثناء تسجيل الدخول")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل الدخول")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'images/logo.png',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "البريد الإلكتروني",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passController,
                    decoration: const InputDecoration(
                      labelText: "كلمة المرور",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("دخول", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text("مستخدم جديد؟ إنشاء حساب"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// RegisterPage
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يرجى ملء جميع الحقول")));
      return;
    }

    // التحقق من صحة البريد الإلكتروني
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال بريد إلكتروني صحيح")),
      );
      return;
    }

    // التحقق من كلمة المرور
    if (passController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("كلمة المرور يجب أن تكون 6 أحرف على الأقل"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dbHelper = DatabaseHelper();

      // التحقق من وجود البريد الإلكتروني مسبقاً
      final existingUser = await dbHelper.getUserByEmail(
        emailController.text.trim(),
      );
      if (existingUser != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("البريد الإلكتروني موجود مسبقاً")),
          );
        }
        return;
      }

      // إضافة المستخدم الجديد
      await dbHelper.insertUser(
        nameController.text.trim(),
        emailController.text.trim(),
        passController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم إنشاء الحساب بنجاح")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("حدث خطأ أثناء إنشاء الحساب")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء حساب")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "الاسم",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              decoration: const InputDecoration(
                labelText: "كلمة المرور",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إنشاء حساب", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

























// import 'package:flutter/material.dart';
// import 'package:hamzahhhhh/screens/home_screen.dart';
// import 'screens/home_screen.dart'; 

// // import 'package:gap/gap.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'main.dart';
// void main() {
//   runApp(MyApp());
// }

// /*
//   List مؤقتة
//   كل حساب: name , email , password
// */
// List<Map<String, String>> accounts = [];

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           "حمزه الشامي \n مخزن النخبة",
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// // Login Page

// class LoginPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("تسجيل الدخول")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "البريد الإلكتروني"),
//             ),
//             TextField(
//               controller: passController,
//               decoration: InputDecoration(labelText: "كلمة المرور"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//           ElevatedButton(
//   child: Text("دخول"),
//   onPressed: () {
//     bool isLogin = false;
//     String name = "";
//     String email = emailController.text;

//     // تحقق من البيانات في accounts
//     for (var acc in accounts) {
//       if (acc["email"] == email &&
//           acc["password"] == passwordController.text) {
//         isLogin = true;
//         name = acc["name"]!;
//         break;
//       }
//     }

//     if (isLogin) {
//       // الانتقال إلى HomeScreen عند النجاح
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => HomeScreen(), // صفحة HomeScreen التي أرفقتها
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("بيانات الدخول غير صحيحة")),
//       );
//     }
//   },
// )
//             TextButton(
//               child: Text("مستخدم جديد؟ إنشاء حساب"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Register Page

// class RegisterPage extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("إنشاء حساب")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "الاسم"),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "البريد الإلكتروني"),
//             ),
//             TextField(
//               controller: passController,
//               decoration: InputDecoration(labelText: "كلمة المرور"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text("إنشاء حساب"),
//               onPressed: () {
//                 accounts.add({
//                   "name": nameController.text,
//                   "email": emailController.text,
//                   "password": passController.text,
//                 });

//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Home Page

// // class HomePage extends StatelessWidget {
// //   final String name;
// //   final String email;

// //   HomePage({required this.name, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
// home: HomeScreen(),
//       //home: HomeScreen(),
//     );
//     //Scaffold(
//     //   appBar: AppBar(title: Text("الصفحة الرئيسية")),
//     //   body: Center(
//     //     child: Column(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       children: [
//     //         Text("مرحبًا $name", style: TextStyle(fontSize: 22)),
//     //         Text("الإيميل: $email"),
//     //         SizedBox(height: 20),
//     //         Text(
//     //           "⚠️ البيانات مؤقتة وتُحذف عند إغلاق التطبيق",
//     //           style: TextStyle(color: Colors.red),
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
// //}
















// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'main.dart';
// // import 'package:world_travel/Pages/Signup.dart';
// // import 'package:world_travel/Pages/forgetpassword.dart';
// // import 'package:world_travel/Pages/welcome.dart';
// // import 'package:world_travel/Widgets/Custom_Container.dart';
// // import 'package:world_travel/Widgets/Custom_Text.dart';
// // import 'package:world_travel/Widgets/Custom_Text_filed.dart';
// // import 'package:world_travel/Widgets/Primary_color.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   bool isChecked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           children: [
//             Gap(20),
//             Image.asset('assets/auth.png', width: 250),
//             // Gap(20),
//             // CustomText(text: 'Welcome Back'),
//             Gap(5),
//             Text(
//               'sign in to access your account',
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),

//             // Gap(20),

//             // CustomTextFiled(
//               // hintText: 'Enter your email',
//               // SuffixIcon: Icons.email_outlined,
//             // ),
//             // Gap(10),
//             // // CustomTextFiled(
//             //   hintText: 'Password',
//             //   SuffixIcon: Icons.visibility_off,
//             // ),

//             Gap(8),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 17),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Transform.scale(
//                         scale: 0.7,
//                         child: Checkbox(
//                           value: isChecked,
//                           onChanged: (value) {
//                             isChecked = value!;
//                           },
//                         ),
//                       ),

//                       Text('Remember me'),
//                     ],
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.push(
//                         // context,
//                         // MaterialPageRoute(builder: (c) => Forgetpassword()),
//                       //  );
//                     },
//                     child: Text(
//                       'Forget password ?',
//                       // style: TextStyle(color: PrimaryColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Gap(20),

//             SizedBox(
//               width: 277,
//               child: Row(
//                 children: [
//                   Expanded(child: Divider(thickness: 2)),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text('or sign in with'),
//                   ),
//                   Expanded(child: Divider(thickness: 2)),
//                 ],
//               ),
//             ),
//             Gap(25),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 90),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(shape: BoxShape.circle),
//                     child: Image.asset(
//                       'assets/google.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(shape: BoxShape.circle),
//                     child: Image.asset(
//                       'assets/facebook.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(shape: BoxShape.circle),
//                     child: Image.asset('assets/x.png', fit: BoxFit.contain),
//                   ),
//                 ],
//               ),
//             ),

//             Gap(25),

//             GestureDetector(
//               onTap: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (c) => Welcome()),
//                 // );
//               },
//               // child: CustomContainer(text: 'Login'),
//             ),
//             Gap(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Don’t have an account? '),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (c) => YemenMarketApp()),
//                     );
//                   },
//                   //child: Text('Sign up', style: TextStyle(color: PrimaryColor)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




