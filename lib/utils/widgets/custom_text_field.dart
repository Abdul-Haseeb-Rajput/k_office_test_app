// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:k_office_test_app/utils/constants/colors.dart';
import 'package:k_office_test_app/utils/constants/text_styles.dart';

class CutsomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? suffix;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;

  const CutsomTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.obscureText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      keyboardType: TextInputType.emailAddress,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      cursorColor: AppColors.black,
      controller: controller,
      style: CustTextStyle.body1,
      decoration: InputDecoration(
        suffix: suffix,

        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        constraints: const BoxConstraints(
          // text field height
          minHeight: 60.0,
        ),
        filled: true,

        // when text field is focused
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.ligthGreen, width: 2.0),
        ),

        // when text field is unfocused
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
