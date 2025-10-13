import 'package:flutter/material.dart';
import 'package:starter/core/theme/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(

            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("clock"),
            style: AppTheme.filledButtonStyle
              ,),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("clock"),
                style: AppTheme.outlinedButtonStyle

            ),
          ],
        ),
      ),
    );
  }
}
