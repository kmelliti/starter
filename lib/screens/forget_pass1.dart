// forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_theme.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/otp_verification.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final bool _isEmailSelected = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 40,
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "استعادة كلمة المرور",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Email/Phone input field
                TextField(
                  controller: _emailOrPhoneController,
                  decoration: InputDecoration(
                    hintText: _isEmailSelected
                        ? "البريد الإلكتروني"
                        : "رقم الجوال",
                  ),
                ),

                const SizedBox(height: 20),

                // "أو" text
                Center(
                  child: Text(
                    "أو",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),

                // Alternative input field
                TextField(
                  decoration: InputDecoration(
                    hintText: _isEmailSelected
                        ? "رقم الجوال"
                        : "البريد الإلكتروني",
                  ),
                ),

                const Spacer(),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppTheme.filledButtonStyle,
                    onPressed: () {
                      Get.to(() => const OtpVerificationPage());
                    },
                    child: const Text("التالي"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// otp_verification_page.dart

// new_password_page.dart

// password_success_page.dart
