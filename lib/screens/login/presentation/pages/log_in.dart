// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:starter/core/theme/app_theme.dart';
// import 'package:starter/core/config/utils.dart';
// import 'package:starter/screens/forget_pass1.dart';
// import 'sign_up1.dart'; // For navigation to the registration step
//
// class SignIn extends StatefulWidget {
//   const SignIn({super.key});
//
//   @override
//   State<SignIn> createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = HexColor.fromHex(AppTheme.primaryColor);
//
//     return Directionality(
//       textDirection: TextDirection.rtl, // Arabic layout
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),
//
//                 // 🔹 Logo
//                 Center(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/ChatGPT Image Oct 17, 2025, 07_32_16 PM.png', // <-- replace with your logo
//                         width: 100,
//                         height: 100,
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // 🔹 Title
//                 const Text(
//                   "تسجيل الدخول",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // 🔹 Form fields
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       _buildTextField("اسم المستخدم", _usernameController),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         "كلمة المرور",
//                         _passwordController,
//                         isPassword: true,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // 🔹 Forgot Password
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: () {
//                       Get.to(() => const ForgotPasswordPage());
//                     },
//                     child: const Text(
//                       "نسيت كلمة المرور؟",
//                       style: TextStyle(color: Colors.black, fontSize: 14),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // 🔹 Login Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: AppTheme.filledButtonStyle,
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         // TODO: Add login logic
//                       }
//                     },
//                     child: const Text("تسجيل الدخول"),
//                   ),
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 // 🔹 Create Account Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: AppTheme.outlinedButtonStyle,
//                     onPressed: () {
//                       Get.to(
//                         () => const SignUpPage1(),
//                         transition: Transition.rightToLeft,
//                         duration: const Duration(milliseconds: 400),
//                       );
//                     },
//                     child: const Text("إنشاء حساب جديد"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // 🔸 Reusable text field
//   Widget _buildTextField(
//     String hint,
//     TextEditingController controller, {
//     bool isPassword = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "الحقل مطلوب";
//         }
//         return null;
//       },
//     );
//   }
// }
