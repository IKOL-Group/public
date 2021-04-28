import 'package:flutter/material.dart';
import 'package:public_app/Routes/Routes.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../ChangePassword.dart';

class OTPVerification extends StatefulWidget {
  final String mobileNumber;
  OTPVerification(this.mobileNumber);
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController otpController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sent to ' + widget.mobileNumber,
          style: kPoppinsTextStyle,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.phone,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40),
                animationDuration: Duration(milliseconds: 300),
                cursorColor: Colors.black,
                enableActiveFill: false,
                controller: otpController,
                onChanged: (value) {}),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 30.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> state) {
                        return kGreenColor;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.home);
                  },
                  child: Text('Verify OTP', style: kPoppinsTextStyle3)),
            ),
          ],
        ),
      ),
    );
  }
}
