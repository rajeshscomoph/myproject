import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LabeledTextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? helperText;
  final String? hintText;
  final IconData? suffixIcon;
  final VoidCallback? suffixAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final void Function(String)? onFieldSubmitted;


  const LabeledTextFormFieldComponent({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.helperText,
    this.hintText,
    this.suffixIcon,
    this.suffixAction,
    this.keyboardType,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0.5.h, top: 1.h),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 1.h,
              vertical: 1.w,
            ),
            suffixIcon: suffixAction != null && suffixIcon != null
                ? Tooltip(
                    message: 'Check if this school code already exists.',
                    child: IconButton(
                      icon: Icon(suffixIcon),
                      onPressed: suffixAction,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
