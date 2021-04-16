import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';

class CustomTextFormFeild2 extends StatelessWidget {
  final Function(String) validator;
  final IconData icon;
  final Widget suffix;
  final bool obscureText;
  final int maxLength;
  final int maxLines;
  final String labelName;
  final String hintName;
  final TextEditingController fieldController;
  final List<TextInputFormatter> textInputFormatter;
  final TextInputType keyboardType;
  final Function function;
  final Function(String) value;
  final bool readOnly;

  CustomTextFormFeild2(
      {this.fieldController,
      this.hintName,
      this.icon,
      this.suffix,
      this.obscureText,
      this.maxLength,
      this.maxLines,
      this.labelName,
      this.textInputFormatter,
      this.keyboardType,
      this.readOnly,
      this.validator,
      this.function,
      this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Icon(icon, size: 30.0),
          ),
          Expanded(
            child: TextFormField(
              obscureText: obscureText,
              maxLength: maxLength,
              maxLines: maxLines,
              onTap: function,
              validator: validator,
              readOnly: readOnly,
              keyboardType: keyboardType,
              inputFormatters: textInputFormatter,
              controller: fieldController,
              onChanged: value,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black)),
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: kGreenColor)),
                  suffix: suffix,
                  counterText: '',
                  hintText: hintName,
                  labelText: labelName,
                  labelStyle: kPoppinsTextStyle,
                  hintStyle: kPoppinsTextStyle2),
              style: kPoppinsTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
