import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_app/Customs/CustomTextFormField2.dart';
import 'package:public_app/Routes/Routes.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';
import 'package:public_app/screens/Auth/RegisterScreen/OTPVerification.dart';

import '../../../Services/HttpService.dart';
import '../../../Services/HttpService.dart';
import '../../../android/platform.dart';
import '../../../android/platform.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController businessController = new TextEditingController()
    ..text = "GHMC";
  GlobalKey<FormState> registerKey = new GlobalKey();
  passwordVisibility() {
    if (showPassword == true) {
      setState(() {
        showPassword = false;
      });
    } else {
      setState(() {
        showPassword = true;
      });
    }
  }

  @override
  void initState() {
    showPassword = true;
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
          "Register",
          style: kPoppinsTextStyle,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: registerKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              SizedBox(height: 30.0),
              new CustomTextFormFeild2(
                validator: validateFields,
                fieldController: nameController,
                readOnly: false,
                obscureText: false,
                hintName: 'Your Name',
                icon: Icons.person,
                maxLines: 1,
              ),
              new CustomTextFormFeild2(
                validator: validateFields,
                fieldController: passwordController,
                suffix: InkWell(
                    child: Icon(!showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onTap: passwordVisibility),
                readOnly: false,
                obscureText: showPassword,
                hintName: 'Password',
                icon: Icons.lock,
                maxLines: 1,
              ),
              new CustomTextFormFeild2(
                validator: validateFields,
                keyboardType: TextInputType.phone,
                fieldController: phoneController,
                maxLength: 10,
                readOnly: false,
                obscureText: false,
                hintName: 'Enter Mobile Number',
                icon: Icons.mobile_friendly,
                maxLines: 1,
              ),
              new CustomTextFormFeild2(
                validator: validateFields,
                keyboardType: TextInputType.emailAddress,
                fieldController: emailController,
                maxLength: 10,
                readOnly: false,
                obscureText: false,
                hintName: 'Enter Email',
                icon: Icons.email_outlined,
                maxLines: 1,
              ),
              new CustomTextFormFeild2(
                validator: validateFields,
                readOnly: true,
                obscureText: false,
                hintName: 'Business Type',
                fieldController: businessController,
                icon: Icons.business,
                maxLines: 1,
              ),
              new Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
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
                        if (registerKey.currentState.validate()) {
                          //Navigator.of(context).pushNamed(Routes.otpVerify, arguments: phoneController.text);
                          var permission =
                              await AndroidMethods.isLocationEnabled();
                          print("permission $permission");
                          var result;
                          if (permission) {
                            Position position =
                                await AndroidMethods.getUserLocation();
                            print("position ${position}");
                            result = await HttpService().userSignUp(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                phoneController.text,
                                '',
                                businessController.text,
                                position.longitude,
                                position.latitude);
                          } else {
                            result = await HttpService().userSignUp(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                phoneController.text,
                                '',
                                businessController.text,
                                null,
                                null);
                          }
                          print("result $result");
                          if (result == "registered") {
                            var login = await HttpService().userSignIn(
                                phoneController.text, passwordController.text);
                            if (login == "401") {
                              //TODO error message
                            } else if (login == "error") {
                              //TODO error message
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.home, (route) {
                                if (route.settings.name == '/') {
                                  return true;
                                }
                                return false;
                              });
                            }
                          } else if (result == "401") {
                            //TODO error message
                          } else {
                            //TODO error message
                          }
                        }
                      },
                      child: Text('Send OTP', style: kPoppinsTextStyle3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String validateFields(String value) {
    if (value.length == 0) {
      return '*Required Field';
    } else {
      return null;
    }
  }
}
