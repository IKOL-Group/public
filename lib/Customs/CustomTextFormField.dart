import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_app/colors/text.dart';

class CustomTextFormFeild extends StatelessWidget {
  final Function(String) validator;
  final Text prefix;
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

  CustomTextFormFeild(
      {this.fieldController,
      this.hintName,
      this.prefix,
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
    return Expanded(
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
          prefix: prefix,
            border: InputBorder.none,
            counterText: '',
            hintText: hintName,
            labelText: labelName,
            labelStyle: kPoppinsTextStyle,
            hintStyle: kPoppinsTextStyle2),
        style: kPoppinsTextStyle,
      ),
    );
  }
}
