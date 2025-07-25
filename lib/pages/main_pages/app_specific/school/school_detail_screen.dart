import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/pages/main_pages/app_specific/school/add_school_screen.dart';
import 'package:myproject/pages/main_pages/app_specific/student/HomePageStudent.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchoolDetailScreen extends StatefulWidget {
  final int schoolCode;
  final IsarService isarService;

  const SchoolDetailScreen({
    super.key,
    required this.schoolCode,
    required this.isarService,
  });

  @override
  State<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends State<SchoolDetailScreen> {
  School? school;

  @override
  void initState() {
    super.initState();
    _loadSchool();
  }

  Future<void> _loadSchool() async {
    final fetchedSchool = await widget.isarService.getSchoolByCode(
      widget.schoolCode,
    );
    setState(() {
      school = fetchedSchool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarComponent(context),
      body: school == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12.sp),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: ListView(
                    children: [
                      _header("🏫 School Information"),
                      SizedBox(height: 1.5.h),
                      _infoTile(
                        Icons.school,
                        'School Name',
                        school!.schoolName,
                      ),
                      _infoTile(
                        Icons.code,
                        'School Code',
                        '${school!.schoolCode}',
                      ),
                      _infoTile(Icons.category, 'Type', school!.schoolType),
                      _infoTile(
                        Icons.person,
                        'Principal',
                        school!.principalName,
                      ),
                      _infoTile(Icons.phone, 'Phone', school!.phone1),
                      SizedBox(height: 3.h),
                      Divider(
                        thickness: 1.2,
                        color: const Color.fromARGB(255, 46, 44, 44),
                      ),
                      SizedBox(height: 2.h),
                      _header("📚 Classes & Sections"),
                      SizedBox(height: 1.5.h),
                      if (school!.classSections.isEmpty)
                        const Text(
                          'No classes added.',
                          style: TextStyle(fontSize: 16),
                        )
                      else
                        ...school!.classSections.map((classSection) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class: ${classSection.className}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 0.8.h),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: classSection.sections.map((
                                    section,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomePageAfterSection(
                                                  schoolCode:
                                                      school!.schoolCode,
                                                  className:
                                                      classSection.className,
                                                  section: section,
                                                  isarService:
                                                      widget.isarService,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Chip(
                                        label: Text(
                                          section,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        shape: const StadiumBorder(),
                                        elevation: 2,
                                      ),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SizedBox(
          width: double.infinity,
          height: 7.h,
          child: ElevatedButton.icon(
            onPressed: _navigateToEditSchool,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.sp),
              ),
              elevation: 6,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              "Edit",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToEditSchool() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit School'),
        content: const Text('Do you want to edit this school\'s details?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Edit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final updatedSchool = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddSchoolScreen(
          isarService: widget.isarService,
          schoolCode: widget.schoolCode,
        ),
      ),
    );

    if (updatedSchool != null && mounted) {
      final refreshedSchool = await widget.isarService.getSchoolByCode(
        widget.schoolCode,
      );
      setState(() {
        school = refreshedSchool; // update local state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ School updated successfully!')),
      );
    }
  }

  Widget _header(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
