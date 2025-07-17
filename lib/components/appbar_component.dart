import 'package:flutter/material.dart';
import 'package:myproject/config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

AppBar appbarComponent(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return AppBar(
    toolbarHeight: 8.h,
    backgroundColor: colorScheme.secondary,
    centerTitle: true,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logos/appLogo.png',
          height: 4.5.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 2.w),
        Text(
          config.appName,
          style: TextStyle(
            color: colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
