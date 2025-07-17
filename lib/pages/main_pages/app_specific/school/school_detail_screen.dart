import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/pages/main_pages/app_specific/student/HomePageStudent.dart'; // import the new page
import 'package:responsive_sizer/responsive_sizer.dart';

class SchoolDetailScreen extends StatelessWidget {
  final School school;

  const SchoolDetailScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarComponent(context),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: ListView(
              children: [
                _infoRow('School Code', '${school.schoolCode}'),
                _infoRow('Type', school.schoolType),
                _infoRow('Principal', school.principalName),
                _infoRow('Phone', school.phone1),
                SizedBox(height: 2.h),
                const Divider(),
                SizedBox(height: 2.h),
                const Text(
                  'Classes & Sections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 2.h),
                if (school.classSections.isEmpty)
                  const Text('No classes added.')
                else
                  ...school.classSections.map((classSection) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class: ${classSection.className}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Wrap(
                            spacing: 8,
                            children: classSection.sections.map((section) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomePageAfterSection(
                                            school: school,
                                            className: classSection.className,
                                            section: section,
                                          ),
                                    ),
                                  );
                                },
                                child: Chip(label: Text(section)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
    );
  }
}
