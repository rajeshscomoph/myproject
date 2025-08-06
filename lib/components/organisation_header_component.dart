import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrganizationHeaderComponent extends StatelessWidget {
  final String organizationName;

  const OrganizationHeaderComponent({super.key, required this.organizationName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: Image.asset(
            'assets/logos/logo.png',
            width: 18.w,
            height: 9.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organizationName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Dr. R.P. Centre for Ophthalmology",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "AIIMS, New Delhi",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
