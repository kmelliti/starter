
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';

class ResetStepThree extends StatefulWidget {
  const ResetStepThree({super.key});

  @override
  State<ResetStepThree> createState() => _ResetStepThreeState();
}

class _ResetStepThreeState extends State<ResetStepThree> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            "new_password".tr,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 20,),

          TextFormField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              hintText: "input_new_password".tr,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: HexColor.fromHex(AppTheme.primaryColor),
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 10,),

          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            decoration: InputDecoration(
              hintText: "reinput_new_password".tr,
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: HexColor.fromHex(AppTheme.primaryColor),

                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              if (value != _passwordController.text) {
                return 'passwords_do_not_match'.tr;
              }
              return null;
            },
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Handle password reset
              }
            },
            child: Text('reset_password'.tr),
          )
        ],
      ),
    );
  }
}
