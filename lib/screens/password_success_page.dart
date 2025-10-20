import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_theme.dart';
import 'package:starter/core/config/utils.dart';

class PasswordSuccessPage extends StatelessWidget {
  const PasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF2E2C54),
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
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "استعادة كلمة المرور",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Success card
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 50,
                            color: Colors.green.shade600,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Success message
                        const Text(
                          "تم تغيير كلمة المرور بنجاح",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          "يمكنك الآن تسجيل الدخول\nباستخدام كلمة المرور الجديدة",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: HexColor.fromHex(
                                AppTheme.primaryColor,
                              ),
                              minimumSize: const Size(double.infinity, 50),
                              elevation: 0,
                              side: BorderSide(
                                color: HexColor.fromHex(AppTheme.primaryColor),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Navigate back to login
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.back();
                            },
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
