import 'package:flutter/material.dart';
import 'package:public_app/Customs/CustomTextFormField.dart';
import 'package:public_app/Routes/Routes.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  // static final route = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  GlobalKey<FormState> logInKey = new GlobalKey();
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
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LogIn",
          style: kPoppinsTextStyle,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Scaffold(
        body: Form(
          key: logInKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: [
                    CustomTextFormFeild(
                      validator: validateFields,
                      readOnly: false,
                      hintName: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      fieldController: phoneController,
                      obscureText: false,
                      maxLength: 10,
                      maxLines: 1,
                      prefix: Text('+91 ', style: kPoppinsTextStyle),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: [
                    CustomTextFormFeild(
                      validator: validateFields,
                      hintName: 'Password',
                      readOnly: false,
                      fieldController: passwordController,
                      obscureText: showPassword,
                      maxLength: 10,
                      maxLines: 1,
                    ),
                    IconButton(
                        icon: Icon(!showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          passwordVisibility();
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    onPressed: () {
                      if (logInKey.currentState.validate()) {
                        Navigator.of(context).pushNamed(Routes.home);
                      }
                    },
                    child: Text('LOG IN', style: kPoppinsTextStyle3)),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'New User? ', style: kPoppinsTextStyle),
                TextSpan(text: 'Sign Up', style: kPoppinsTextStyle4)
              ]))
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
