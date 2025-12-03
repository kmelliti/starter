// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:starter/core/theme/app_theme.dart';
// import 'package:starter/core/config/utils.dart';
// import 'package:starter/screens/login/presentation/pages/log_in.dart';
// import 'package:starter/screens/login/presentation/pages/sign_up2.dart';
//
// class SignUpPage1 extends StatefulWidget {
//   const SignUpPage1({super.key});
//
//   @override
//   State<SignUpPage1> createState() => _SignUpPage1State();
// }
//
// class _SignUpPage1State extends State<SignUpPage1> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _companyNameController = TextEditingController();
//   final TextEditingController _commercialNumberController =
//       TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   String? selectedCategory;
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🔹 Header with back arrow and title
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Get.to(() => const SignIn());
//                         },
//                         icon: const Icon(
//                           Icons.arrow_circle_right_outlined,
//                           size: 50,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         "إنشاء حساب",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//                   // 🔹 Section title
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "معلومات الشركة",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const Text(
//                         "1/2",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ],
//                   ),
//
//                   // 🔹 Progress text
//                   const SizedBox(height: 6),
//
//                   // 🔹 Progress bar
//                   LinearProgressIndicator(
//                     value: 0.5,
//                     color: HexColor.fromHex(AppTheme.primaryColor),
//                     backgroundColor: Colors.grey.shade200,
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // 🔹 Upload logo circle
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: HexColor.fromHex(AppTheme.primaryColor),
//                             style: BorderStyle.solid,
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.file_upload_outlined,
//                               color: HexColor.fromHex(AppTheme.primaryColor),
//                               size: 30,
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               "رفع الشعار",
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // 🔹 Input fields
//                   _buildTextField("اسم الشركة", _companyNameController),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     "رقم السجل التجاري",
//                     _commercialNumberController,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField("العنوان الوطني", _addressController),
//                   const SizedBox(height: 16),
//
//                   // 🔹 Upload Tax Certificate
//                   _buildUploadField("الشهادة الضريبية"),
//                   const SizedBox(height: 16),
//
//                   // 🔹 Upload Trade License
//                   _buildUploadField("صورة السجل التجاري*"),
//                   const SizedBox(height: 16),
//
//                   // 🔹 Category dropdown
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         icon: Icon(Icons.keyboard_arrow_down),
//                         hint: const Text("الفئة"),
//                         value: selectedCategory,
//                         isExpanded: true,
//                         items: ["مقاولات", "تقنية", "تجارة"]
//                             .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)),
//                             )
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // 🔹 Next button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: AppTheme.filledButtonStyle,
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           Get.to(() => const SignUpPage2());
//                         }
//                       },
//                       child: const Text("التالي"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Reusable input field
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//       ),
//       validator: (value) =>
//           value == null || value.isEmpty ? "الحقل مطلوب" : null,
//     );
//   }
//
//   // Reusable upload field
//   Widget _buildUploadField(String label) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.grey.shade300),
//           color: Color(0xFFF8F8FF),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label),
//             Icon(
//               Icons.file_upload_outlined,
//               color: HexColor.fromHex(AppTheme.primaryColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
