import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/di/di.dart';
import 'package:starter/screens/reset_password/controller/reset_password_controller.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';

typedef OnNextTap = void Function();

class ResetStepOne extends StatelessWidget {
  ResetStepOne({super.key, required this.onNextTap});

  final OnNextTap onNextTap;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final ResetPasswordController _controller = getIt();

  final _keyForm = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          SizedBox(height: 60),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty && mobileController.text.isEmpty) {
                return "email_phone_required".tr;
              }
              if (value.isNotEmpty && !value.isEmail) {
                return "invalid_email".tr;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "email".tr,
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: HexColor.fromHex("#CDCCE0"))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "or".tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HexColor.fromHex(AppTheme.primaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Divider(color: HexColor.fromHex("#CDCCE0"))),
            ],
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: mobileController,
            validator: (value) {
              if (value!.isEmpty && emailController.text.isEmpty) {
                return "email_phone_required".tr;
              }
              if (value.isNotEmpty && !isValidSaudiPhone(value)) {
                return "invalid_phone_number".tr;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "mobile".tr,
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
          ),

          Spacer(),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, val, _) {
              return val
                  ? Center(child: getLoader())
                  : ElevatedButton(
                    onPressed: () async {
                      if (!_keyForm.currentState!.validate()) {
                        return;
                      }
                      isLoading.value = true;
                      try {
                        String code = await _controller.codeResetPassword({
                          "email": emailController.text,
                          "phone": mobileController.text,
                        });
                        _controller.code = code;
                        _controller.userContacts = {
                          "email": emailController.text,
                          "phone": mobileController.text,
                        };
                        onNextTap();
                      } catch (e, s) {
                        handleException(context, e);
                      }
                      isLoading.value = false;
                    },
                    child: Text("next".tr),
                  );
            },
          ),
        ],
      ),
    );
  }
}
