import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/theme/app_theme.dart';

class ContactLinksPage extends StatefulWidget {
  const ContactLinksPage({super.key});

  @override
  State<ContactLinksPage> createState() => _ContactLinksPageState();
}

class _ContactLinksPageState extends State<ContactLinksPage> {

  List<String> platforms = [];
  TextEditingController tiktokController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController xController = TextEditingController();
  @override
  void initState() {
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
              ElevatedButton(onPressed: (){}, child: Text("save".tr))

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
