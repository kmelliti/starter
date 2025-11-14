import 'dart:async';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';


typedef OnNextTap = void Function();

class ResetStepTwo extends StatefulWidget {
  const ResetStepTwo({super.key, required this.onNextTap});

  final OnNextTap onNextTap;
  @override
  _ResetStepTwoState createState() => _ResetStepTwoState();
}

class _ResetStepTwoState extends State<ResetStepTwo> {
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  bool _canResendCode = false;
  Timer? _timer;
  int _start = 59;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _canResendCode = false;
    _timer?.cancel(); // Cancel any existing timer
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _canResendCode = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String getCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 60,),
          Text("input_otp".tr,style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _codeControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,

                    decoration: InputDecoration(
                      counterText: '',
                      hintText: "-",
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                    onChanged: (value) => _onCodeChanged(value, index),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          _canResendCode
              ? Container()
              : Text(
                "00:${(_start - (_timer?.tick ?? 0))}".trParams({
                  'seconds': _start.toStringAsFixed(2),
                }),
              ),

          SizedBox(height: 20,),
          Text("otp_failed".tr,style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: HexColor.fromHex(AppTheme.primaryColor),
            fontWeight: FontWeight.w500,
          ),),
          TextButton(
            onPressed: () {
              // TODO: Resend code functionality
              setState(() {
                _start = 60; // Reset timer
              });
              startTimer();
            },
            child: Text("resend_code".tr,style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: HexColor.fromHex(AppTheme.primaryColor),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              bool allFilled = _codeControllers.every(
                (controller) => controller.text.isNotEmpty,
              );
              if (allFilled) {
                final code = getCode();
                widget.onNextTap();
                // TODO: Send code to server
                print('Verification code: $code');
              }
            },
            child: Text("next".tr),
          ),
        ],
      ),
    );
  }
}
