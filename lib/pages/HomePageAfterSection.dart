// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/pages/StudentDetailScreen.dart';
import 'package:myproject/pages/ViewStudentsPage.dart'; // import the real view page
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageAfterSection extends StatelessWidget {
  final School school;
  final String className;
  final String section;

  const HomePageAfterSection({
    super.key,
    required this.school,
    required this.className,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Section: $className - $section')),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Add Student'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailScreen(
                        className: className,
                        section: section,
                        school: school,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('View Students'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewStudentsPage(
                        school: school,
                        className: className,
                        section: section,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
