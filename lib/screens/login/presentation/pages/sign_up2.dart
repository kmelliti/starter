import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/theme/app_theme.dart';
import 'package:starter/core/config/utils.dart';
import 'sign_up1.dart'; // For navigation back

class SignUpPage2 extends StatelessWidget {
  const SignUpPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor.fromHex(AppTheme.primaryColor);
    final borderColor = HexColor.fromHex(AppTheme.textFieldBorder);

    return Directionality(
      textDirection: TextDirection.rtl, // Arabic layout
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Progress indicator
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '2/2',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey.shade300,
                  color: primaryColor,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 12),
                Text(
                  'بيانات الموظف',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                // Text fields
                _buildTextField("الاسم الكامل"),
                _buildTextField("البريد الإلكتروني"),
                _buildTextField("رقم الهاتف"),

                const SizedBox(height: 12),

                // Dropdown (الدولة)
                Container(
                  height: 55,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الدولة",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Buttons Row (إنشاء حساب + رجوع)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: AppTheme.outlinedButtonStyle,
                        onPressed: () {
                          Get.to(() => const SignUpPage1());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.arrow_back,
                              color: Color(0xFF2A2767),
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text("رجوع"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: AppTheme.filledButtonStyle,
                        onPressed: () {},
                        child: const Text("إنشاء حساب"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(decoration: InputDecoration(hintText: hint)),
    );
  }
}
