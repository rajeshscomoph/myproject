import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchoolInfoCard extends StatelessWidget {
  final School school;
  final String className;
  final String section;

  const SchoolInfoCard({
    super.key,
    required this.school,
    required this.className,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      elevation: 5,
      shadowColor: colorScheme.primary.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.sp)),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 16.sp),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                SizedBox(width: 10.sp),
                Text(
                  'School, Class & Section Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _infoRow(
                  Icons.domain,
                  'School Name (Code)',
                  '${school.schoolName} (${school.schoolCode})',
                ),
                _infoRow(
                  Icons.class_,
                  'Class',
                  '$className - $section',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: Colors.grey[700]),
          SizedBox(width: 2.w),
          Flexible(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
