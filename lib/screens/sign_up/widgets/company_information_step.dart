import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/core/models/lookup_model.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../presentation/controller/sign_up_controller.dart';

typedef OnNextStep = void Function();

class PersonalInformationStep extends StatefulWidget {
  PersonalInformationStep({super.key, required this.onNextStep});

  final OnNextStep onNextStep;

  @override
  State<PersonalInformationStep> createState() =>
      _PersonalInformationStepState();
}

class _PersonalInformationStepState extends State<PersonalInformationStep>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<String?> companyLogo = ValueNotifier(null);

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _companyNameController = TextEditingController();

  final TextEditingController _tradeLicenseController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _signUpController = getIt<SignUpController>();

  late final AnimationController _animationController;
  int? selectedCategory;

  final ValueNotifier<String?> tradeLicenseDocument = ValueNotifier(null);
  final ValueNotifier<String?> taxDocument = ValueNotifier(null);

  bool rneError = false;
  bool taxError = false;
  bool logoError = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _companyNameController.text =
          _signUpController.accountCreationParams.companyName ?? '';
      _tradeLicenseController.text =
          _signUpController.accountCreationParams.tradeLicenseNumber ?? '';
      _addressController.text =
          _signUpController.accountCreationParams.address ?? '';
      companyLogo.value =
          _signUpController.accountCreationParams.companyLogo ?? null;
      tradeLicenseDocument.value =
          _signUpController.accountCreationParams.tradeLicenseNumber ?? null;
      taxDocument.value =
          _signUpController.accountCreationParams.taxCertificate ?? null;
      if(_signUpController.accountCreationParams.categoryId != null)
      selectedCategory = int.parse(_signUpController.accountCreationParams.categoryId!);
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildSafeArea(context));
  }

  SafeArea buildSafeArea(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: DottedBorder(
                    animation: _animationController,
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(60),
                      dashPattern: const [8, 4],
                      strokeWidth: 1,
                      color: logoError ? Colors.red :HexColor.fromHex(AppTheme.primaryColor),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: companyLogo,
                      builder: (context, img, _) {
                        return InkWell(
                          onTap: () {
                            _picker.pickImage(source: ImageSource.gallery).then(
                              (value) {
                                if (value != null) {
                                  companyLogo.value = value.path;
                                }
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: logoError ? Colors.red :HexColor.fromHex("#F8F8FF"),
                              shape: BoxShape.circle,
                            ),
                            height: 120,
                            width: 120,
                            child:
                                img != null
                                    ? CircleAvatar(
                                      radius: 60,
                                      backgroundImage: FileImage(File(img)),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/upload.svg",
                                          width: 15,
                                          color: HexColor.fromHex(
                                            AppTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'upload_logo'.tr,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: HexColor.fromHex(
                                              AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'company_name'.tr),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'field_is_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tradeLicenseController,
                  keyboardType: TextInputType.number,


                  decoration: InputDecoration(
                    labelText: 'rne_number'.tr,
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'field_is_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'national_address'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'field_is_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: taxDocument,
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          taxDocument.value = file.path;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:  HexColor.fromHex("#F8F8FF"),
                          border: Border.all(
                            color: taxError ?Colors.red : HexColor.fromHex(AppTheme.primaryColor),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value == null
                                  ? "fiscal_certificate".tr
                                  : value.split("/").last.toString(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: HexColor.fromHex(AppTheme.primaryColor),
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/upload.svg",
                              color: HexColor.fromHex(AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: tradeLicenseDocument,
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          tradeLicenseDocument.value = file.path;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: HexColor.fromHex("#F8F8FF"),
                          border: Border.all(
                            color:  rneError ?Colors.red : HexColor.fromHex(AppTheme.primaryColor),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value == null
                                  ? "rne_document".tr
                                  : value.split("/").last.toString(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: HexColor.fromHex(AppTheme.primaryColor),
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/upload.svg",
                              color: HexColor.fromHex(AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<LookUpModel>(

                  value: selectedCategory != null ? merchantCategories.firstWhere((element) => element.id == selectedCategory) : null,
                  decoration: InputDecoration(labelText: 'category'.tr),
                  items:
                      merchantCategories
                          .map(
                            (e) => DropdownMenuItem<LookUpModel>(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    selectedCategory = value?.id;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'field_is_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      if(taxDocument.value == null){
                        setState(() {
                          taxError = true;
                        });

                      }
                      if(tradeLicenseDocument.value == null){
                        setState(() {
                          rneError = true;
                        });
                      }
                      if(companyLogo.value == null){
                        setState(() {
                          logoError = true;
                        });
                      }
                      widget.onNextStep();
                      if (_formKey.currentState!.validate()) {
                        _signUpController.accountCreationParams.companyLogo = companyLogo.value;
                        _signUpController.accountCreationParams.companyName =
                            _companyNameController.text;
                        _signUpController.accountCreationParams.tradeLicenseNumber =
                            _tradeLicenseController.text;
                        _signUpController.accountCreationParams.address =
                            _addressController.text;
                        _signUpController.accountCreationParams.taxCertificate = taxDocument.value;
                        _signUpController.accountCreationParams.copyTradeLicense = tradeLicenseDocument.value;
                        _signUpController.accountCreationParams.categoryId = selectedCategory?.toString();

                        widget.onNextStep();
                      }
                    },
                    child: Text('next'.tr),
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
