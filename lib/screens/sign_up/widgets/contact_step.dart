import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../presentation/controller/sign_up_controller.dart';

typedef OnNextStep = void Function();
typedef OnBackStep = void Function();

class ContactStep extends StatefulWidget {
  ContactStep({super.key, required this.onNextStep, required this.onBackStep});

  final OnNextStep onNextStep;
  final OnBackStep onBackStep;

  @override
  State<ContactStep> createState() => _ContactStepState();
}

class _ContactStepState extends State<ContactStep> {
  final _signUpController = getIt<SignUpController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _birthdayController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();
  String? _gender;

  @override
  void initState() {

    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _fullNameController.text =
          _signUpController.accountCreationParams.name ?? '';
      if (_signUpController.accountCreationParams.birthday != null) {
        _birthdayController.text = df.format(
          _signUpController.accountCreationParams.birthday!,
        );
      }

      _emailController.text =
          _signUpController.accountCreationParams.email ?? '';
      _phoneNumberController.text =
          _signUpController.accountCreationParams.phone ?? '';
      if (_signUpController.accountCreationParams.gender != null)
        _gender = _signUpController.accountCreationParams.gender!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 40),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(labelText: 'full_name'.tr),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,

            decoration: InputDecoration(labelText: 'email'.tr),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'phone_number'.tr),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _birthdayController,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'dob'.tr,
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: HexColor.fromHex(AppTheme.primaryColor),
              ),
            ),
            onTap: () async {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value == null) {
                  return;
                }
                _birthdayController.text = DateFormat(
                  'dd-MM-yyyy',
                ).format(value);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'gender'.tr),
            items: [
              DropdownMenuItem(value: "male", child: Text('male'.tr)),
              DropdownMenuItem(value: "female", child: Text('female'.tr)),
            ],
            onChanged: (value) {
              _gender = value;
            },
            validator: (value) {
              if (value == null) {
                return 'field_is_required'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onBackStep();
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
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUpController.accountCreationParams.name =
                          _fullNameController.text;

                      _signUpController.accountCreationParams.birthday = df
                          .parse(_birthdayController.text);

                      _signUpController.accountCreationParams.email =
                          _emailController.text;

                      _signUpController.accountCreationParams.phone =
                          _phoneNumberController.text;
                      _signUpController.accountCreationParams.gender =
                          _gender.toString();

                      widget.onNextStep();
                    }
                  },
                  child: Text('next'.tr),
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
