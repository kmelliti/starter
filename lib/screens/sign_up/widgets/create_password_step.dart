import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../presentation/controller/sign_up_controller.dart';

typedef OnNextStep = void Function();
typedef OnBackStep = void Function();

class CreatePasswordStep extends StatelessWidget {
  CreatePasswordStep({
    super.key,
    required this.onNextStep,
    required this.onBackStep,
  });

  final OnNextStep onNextStep;
  final OnBackStep onBackStep;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final _signUpController = getIt<SignUpController>();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 30),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "field_is_required".tr;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'password'.tr,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordConfirmationController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "field_is_required".tr;
              }
              if (value != _passwordController.text) {
                return "passwords_do_not_match".tr;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'password_confirmation'.tr,
              border: OutlineInputBorder(),
            ),
          ),

          Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onBackStep();
                  },
                  style: AppTheme.outlinedButtonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 10),
                      Text('back'.tr),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, v, _) {
                    return v
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        )
                        : ElevatedButton(
                          onPressed: () async {

                            log(_signUpController.accountCreationParams.toJson().toString());
                            return;
                            if (_formKey.currentState!.validate()) {
                              _signUpController.accountCreationParams.password =
                                  _passwordController.text;
                              log(
                                "data ${_signUpController.accountCreationParams}",
                              );
                              try {
                                isLoading.value = true;
                                await _signUpController.signUp(
                                  _signUpController.accountCreationParams,
                                );
                                _signUpController.showSuccessDialog(context);
                              } catch (e, s) {
                                showErrorDialog(context, "error_body".tr);

                                log(e.toString());
                                log(s.toString());
                              }
                              isLoading.value = false;
                            }
                            //    onNextStep();
                          },
                          child: Text('create'.tr),
                        );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
