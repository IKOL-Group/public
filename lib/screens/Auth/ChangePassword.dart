import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_app/Customs/CustomTextFormField2.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/HttpService.dart';

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

  GlobalKey<FormState> passKey = new GlobalKey();

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
        child: Form(
          key: passKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              new CustomTextFormFeild2(
                  labelName: 'Current Password',
                  suffix: InkWell(
                      child: Icon(!currentPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onTap: () {
                        setState(() {
                          currentPassword = !currentPassword;
                        });
                      }),
                  fieldController: currentPasswordController,
                  readOnly: false,
                  obscureText: currentPassword,
                  maxLines: 1),
              new CustomTextFormFeild2(
                  labelName: 'New Password',
                  suffix: InkWell(
                      child: Icon(!newPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onTap: () {
                        setState(() {
                          newPassword = !newPassword;
                        });
                      }),
                  fieldController: newPasswordController,
                  readOnly: false,
                  obscureText: newPassword,
                  maxLines: 1),
              new CustomTextFormFeild2(
                validator: validateConfirmPassword,
                labelName: 'Confirm Password',
                suffix: InkWell(
                  child: Icon(confirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onTap: () {
                    setState(() {
                      confirmPassword = !confirmPassword;
                    });
                  },
                ),
                fieldController: confirmPasswordController,
                readOnly: false,
                obscureText: confirmPassword,
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 30.0)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> state) {
                          return kGreenColor;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        )),
                    onPressed: () async {
                      if (passKey.currentState.validate()) {
                        print("valid");
                        String result = await HttpService().userChangePassword(
                          currentPasswordController.text,
                          newPasswordController.text,
                        );
                        if (result == 'success') {
                          Navigator.of(context).pop();
                        } else if (result == '401') {
                          Fluttertoast.showToast(msg: "401 Error. Unable to change password.");
                        } else {
                          Fluttertoast.showToast(msg: "Unknown Error. Unable to change password.");
                        }
                      } else {
                        print("in-valid");
                        Fluttertoast.showToast(msg: "Fill the form correctly.");
                      }

                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));*/
                    },
                    child: Text('Update Password', style: kPoppinsTextStyle3)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String validateConfirmPassword(String value) {
    if (value == newPasswordController.text) {
      return null;
    } else {
      return "Password does not match";
    }
  }
}
