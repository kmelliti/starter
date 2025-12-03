import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/core/models/user_model.dart';

import '../../../core/di/di.dart';
import '../../../core/services/app_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../my_account/controller/my_account_controller.dart';

class ContactLinksPage extends StatefulWidget {
  const ContactLinksPage({super.key});

  @override
  State<ContactLinksPage> createState() => _ContactLinksPageState();
}

class _ContactLinksPageState extends State<ContactLinksPage> {
  final MyAccountController _controller = getIt();
  final AppServices appServices = getIt();

  List<String> platforms = [];
  TextEditingController tiktokController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController xController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  late UserModel user ;
  @override
  void initState() {
    user = appServices.getUser();
    tiktokController.text = user.merchant.linkTiktok ?? "";
    instagramController.text = user.merchant.linkInstagram ?? "";
    facebookController.text = user.merchant.linkFacebook ?? "";
    xController.text = user.merchant.linkX ?? "";
    super.initState();
  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              pushUpAnimation(
                 Row(
                  children: [
                    SvgPicture.asset("assets/icons/speaker.svg",color: HexColor.fromHex(AppTheme.primaryColor),),
                    SizedBox(width: 10,),
                    Text("communication".tr,style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 18,
                        color:  HexColor.fromHex(AppTheme.primaryColor)
                    ),)
                  ],
                ),
              ),
              SizedBox(height: 20,),
              platformBlock(context,tiktokController,"tiktok".tr,"tiktok"),
              SizedBox(height: 10,),
              platformBlock(context,instagramController,"instagram".tr,"instagram"),
              SizedBox(height: 10,),
              platformBlock(context,facebookController,"facebook".tr,"facebook"),
              SizedBox(height: 10,),
              platformBlock(context,xController,"x".tr,"x"),
              SizedBox(height: 10,),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context,v,_) {
                  return v ? getLoader() : ElevatedButton(onPressed: () async{

                    isLoading.value = true;
                    Map<String,dynamic> params = {
                      "link_tiktok": tiktokController.text,
                      "link_instagram": instagramController.text,
                      "link_facebook": facebookController.text,
                      "link_x": xController.text,
                    };
                    try{
                      await _controller.updateMediaLinks(params);
                      user.merchant.linkTiktok = tiktokController.text;
                      user.merchant.linkInstagram = instagramController.text;
                      user.merchant.linkFacebook = facebookController.text;
                      user.merchant.linkX = xController.text;
                      appServices.setUser(user);
                      Get.back();
                    }catch(e){
                      handleException(context, e);
                    }
                    isLoading.value = false;

                  }, child: Text("save".tr));
                }
              )

            ],
          ),
        ),
      ),
    );


  }

  Widget platformBlock(BuildContext context,TextEditingController controller, String title,String icon){
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(

        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: HexColor.fromHex("#EBEBEB")),
          borderRadius: BorderRadius.circular(10),
        ),
        child:Column(
          children: [
            Row(
              children: [
                Image.asset("assets/images/$icon.png",width: 25,),
                SizedBox(width: 10,),
                Text(title,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color:HexColor.fromHex(AppTheme.primaryColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            SizedBox(height: 30,),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "account_link".tr
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
            )
          ],
        ),
      ),
    );
  }
}
