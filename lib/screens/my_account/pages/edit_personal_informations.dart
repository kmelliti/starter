import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/core/config/exceptions/api_exception.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/core/models/user_model.dart';
import 'package:starter/core/services/app_service.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/my_account_controller.dart';

class EditPersonalInformation extends StatefulWidget {
  EditPersonalInformation({super.key});

  @override
  State<EditPersonalInformation> createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  final _formKey = GlobalKey<FormState>();

  final MyAccountController _controller = getIt();

  late final UserModel user;

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _birthdayController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final AppServices _appServices = getIt();

  String? gender;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    user = _appServices.getUser();
    _fullNameController.text = user.name;
    if (user.birthdate != null)
      _birthdayController.text = df.format(user.birthdate!);
    _emailController.text = user.email;
    _phoneNumberController.text = user.phone;
    gender = user.gender;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return Scaffold(
            appBar: buildAppBarWithBack(context),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      pushUpAnimation(
                          Text("profile".tr, style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                              color: HexColor.fromHex("#1E1D33"),
                              fontSize: 16
                          ),)
                      ),
                      SizedBox(height: 10),
                      pushUpAnimation(
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/my_account.svg",
                              width: 15,),
                            SizedBox(width: 10,),
                            Text("personal_info".tr, style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                color: HexColor.fromHex("#1E1D33"),
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      pushUpAnimation(
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(labelText: 'full_name'
                              .tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_is_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      pushUpAnimation(
                        TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(labelText: 'email'.tr),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'field_is_required'.tr;
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 20),
                      pushUpAnimation(
                        TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(labelText: 'phone_number'
                              .tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_is_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      pushUpAnimation(
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
                              _birthdayController.text =
                                 df.format(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_is_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      pushUpAnimation(
                        DropdownButtonFormField<String>(
                          value: gender,
                          decoration: InputDecoration(labelText: 'gender'.tr),
                          items: genderList
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text("$e".tr)))
                              .toList(),
                          onChanged: (value) {
                            gender = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'field_is_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context,v,_) {
                          return v ? Center(child: getLoader()) :pushUpAnimation(
                            ElevatedButton(
                              onPressed: () async{
                                if (_formKey.currentState!.validate()) {
                                  final UpdateUserParams params = UpdateUserParams(
                                      name: _fullNameController.text,
                                      phone: _phoneNumberController.text,
                                      email: _emailController.text,
                                      birthdate: df.parse(_birthdayController.text),
                                      gender: gender!);

                                  isLoading.value= true;
                                  try{
                                    await _controller.updateUserParams(params);
                                  }catch( e,s){


                                    handleException(context,e);
                                  }
                                  isLoading.value = false;
                                }
                              },
                              child: Text('save'.tr),
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
