import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_app/core/theme/app_color.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    this.onPressed,
    required this.text,
    this.horizontalMargin = 24,
    this.verticalMargin = 12,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String? text;
  final double horizontalMargin;
  final double verticalMargin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: GestureDetector(
            onTap: onPressed ?? () {},
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: horizontalMargin, vertical: verticalMargin),
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: onPressed == null ? Color(0xFFE9D6FE) : null,
                gradient: onPressed == null
                    ? null
                    : LinearGradient(
                        colors: AppColor.primaryGradient,
                      ),
              ),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(text ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                  ))),
            )));
  }
}

class AppOutLineButton extends StatelessWidget {
  const AppOutLineButton(
      {super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFFCFCFC)),
        ),
        child: Center(
          child: Text(
            "Sign up",
            style: textTheme.titleMedium
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
