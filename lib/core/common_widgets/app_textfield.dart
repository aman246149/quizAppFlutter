import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class AppTextfield extends StatelessWidget {
  const AppTextfield(
      {super.key,
      this.hintText,
      this.controller,
      this.keyboardType,
      this.validator,
      this.suffixIcon,
      this.obscureText = false,
      this.onChanged});
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Color(0xFFDCDCDC),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17.5),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(0xFF989898),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF989898)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.errorColor),
        ),
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColor.errorColor,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
        suffixIcon: suffixIcon,
        errorMaxLines: null,
        isDense: true,
      ),
    );
  }
}


class AppLabel extends StatelessWidget {
  const AppLabel({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
    );
  }
}
