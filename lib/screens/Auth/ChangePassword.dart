import 'package:flutter/material.dart';
import 'package:public_app/Customs/CustomTextFormField2.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  bool currentPassword;
  bool newPassword;
  bool confirmPassword;

  @override
  void initState() {
    currentPassword = true;
    newPassword = true;
    confirmPassword = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  passwordVisibility() {
    if (currentPassword = true) {
      setState(() {
        currentPassword = false;
      });
    } else {
      setState(() {
        currentPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: kPoppinsTextStyle,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            new CustomTextFormFeild2(
                labelName: 'Current Password',
                suffix: InkWell(
                    child: Icon(!currentPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onTap: passwordVisibility),
                fieldController: currentPasswordController,
                readOnly: false,
                obscureText: currentPassword,
                maxLines: 1),
            new CustomTextFormFeild2(
                labelName: 'New Password',
                suffix: InkWell(
                    child: Icon(
                        !newPassword ? Icons.visibility : Icons.visibility_off),
                    onTap: () {
                      passwordVisibility();
                    }),
                fieldController: newPasswordController,
                readOnly: false,
                obscureText: newPassword,
                maxLines: 1),
            new CustomTextFormFeild2(
                labelName: 'Confirm Password',
                suffix: InkWell(
                    child: Icon(!confirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onTap: () {
                      passwordVisibility();
                    }),
                fieldController: confirmPasswordController,
                readOnly: false,
                obscureText: confirmPassword,
                maxLines: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                  child: Text('Update Password', style: kPoppinsTextStyle3)),
            ),
          ],
        ),
      ),
    );
  }
}
