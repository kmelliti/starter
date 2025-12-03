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

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/app_service.dart';
import '../../../core/theme/app_theme.dart';

class EditCompanyInformation extends StatefulWidget {
  EditCompanyInformation({super.key});

  @override
  State<EditCompanyInformation> createState() => _EditCompanyInformationState();
}

class _EditCompanyInformationState extends State<EditCompanyInformation>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<String?> userImage = ValueNotifier(null);

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _companyNameController = TextEditingController();

  final TextEditingController _rneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final UserModel user;

  final AppServices _appServices = getIt();

  String? _gender;
  late final AnimationController _animationController;

  final ValueNotifier<String?> rneDocument = ValueNotifier(null);
  final ValueNotifier<String?> taxDocument = ValueNotifier(null);

  int? selectedCategory;
  String? companyLogo;

  @override
  void initState() {
    user = _appServices.getUser();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _companyNameController.text = user.merchant.companyName;
    _rneController.text = user.merchant.tradeLicenseNumber;
    _addressController.text = user.merchant.address;
    selectedCategory = user.merchant.categoryId;
    companyLogo=  user.merchant.picture;

    super.initState();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: buildSafeArea(context),
    );
  }

  Widget buildImageContainer() {
    return companyLogo != null ? Center(
      child: Stack(
        children: [
          Container(
            height: 120,
            width: 120,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: HexColor.fromHex("#F8F8FF"),
              shape: BoxShape.circle,
              border: Border.all(
                color: HexColor.fromHex(AppTheme.primaryColor),
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: Image.network("$baseUrlImage/${user.merchant.picture}").image,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: InkWell(
              onTap: (){
                companyLogo = null;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor.fromHex(AppTheme.primaryColor),
                ),
                child: SvgPicture.asset(
                  "assets/icons/upload.svg",
                  width: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        ],
      ),
    ):Center(
      child: DottedBorder(
        animation: _animationController,
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(60),
          dashPattern: const [8, 4],
          strokeWidth: 1,
          color: HexColor.fromHex(AppTheme.primaryColor),
        ),
        child: ValueListenableBuilder(
          valueListenable: userImage,
          builder: (context, img, _) {
            return InkWell(
              onTap: () {
                _picker
                    .pickImage(source: ImageSource.gallery)
                    .then((value) {
                  if (value != null) {
                    userImage.value = value.path;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor.fromHex("#F8F8FF"),
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
    );
  }

  Widget buildSafeArea(BuildContext context) {
    return pushUpAnimation(
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/company.svg",
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "company_info".tr,
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(
                          fontSize: 18,
                          color: HexColor.fromHex(AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildImageContainer(),

                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(labelText: 'company_name'.tr),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_is_required'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _rneController,
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
                    decoration: InputDecoration(
                      labelText: 'national_address'.tr,
                    ),
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
                            color: HexColor.fromHex("#F8F8FF"),
                            border: Border.all(
                              color: HexColor.fromHex(AppTheme.primaryColor),
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
                                  color: HexColor.fromHex(
                                    AppTheme.primaryColor,
                                  ),
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
                    valueListenable: rneDocument,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            rneDocument.value = file.path;
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
                              color: HexColor.fromHex(AppTheme.primaryColor),
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
                                  color: HexColor.fromHex(
                                    AppTheme.primaryColor,
                                  ),
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
                    value:
                        selectedCategory != null
                            ? merchantCategories.firstWhere(
                              (element) => element.id == selectedCategory,
                            )
                            : null,
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
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Text('save'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
