import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repore_chat/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.child,
    this.loading = false,
  });

  final String text;
  final void Function()? onPressed;
  final Widget? child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.w),
      onTap: loading ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20.w),
        ),
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: 17.w,
                width: 17.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : child ??
                Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
      ),
    );
  }
}
