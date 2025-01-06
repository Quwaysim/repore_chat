import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repore_chat/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final void Function(String)? onSubmitted;
  final String? hint;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.hint,
    this.fillColor,
    
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      cursorHeight: 16.h,
      obscureText: widget.isPasswordField ? _obscureText : false,
      maxLines: widget.isPasswordField ? 1 : widget.maxLines,
      minLines: widget.isPasswordField ? 1 : widget.minLines,
      textCapitalization: widget.textCapitalization,
      onFieldSubmitted: widget.onSubmitted,
    
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        labelText: widget.isPasswordField ? 'Password' : widget.label,
        hintText: widget.hint,
        fillColor: widget.fillColor,
        hintStyle: TextStyle(
          color: AppColors.color98A2B3,
          fontSize: 14.sp,
        ),
        prefixIcon: widget.isPasswordField ? const Icon(Icons.lock) : widget.prefixIcon,
        suffixIcon: widget.isPasswordField
            ? InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.color0071BC,
                ),
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
          borderSide: const BorderSide(color: AppColors.colorEAECF0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
          borderSide: const BorderSide(color: AppColors.color0071BC, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.w),
          ),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
