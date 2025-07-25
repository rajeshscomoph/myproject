// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/pages/main_pages/app_specific/student/add_StudentDetail.dart';
import 'package:myproject/pages/main_pages/app_specific/student/ViewStudentsPage.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageAfterSection extends StatefulWidget {
  final int schoolCode;
  final String className;
  final String section;
  final IsarService isarService;

  const HomePageAfterSection({
    super.key,
    required this.schoolCode,
    required this.className,
    required this.section,
    required this.isarService,
  });

  @override
  State<HomePageAfterSection> createState() => _HomePageAfterSectionState();
}

class _HomePageAfterSectionState extends State<HomePageAfterSection> {
  late School school;
  bool isLoading = true;

  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  @override
  void initState() {
    super.initState();
    _loadSchool();
  }

  Future<void> _loadSchool() async {
    final fetchedSchool = await widget.isarService.getSchoolByCode(
      widget.schoolCode,
    );
    if (fetchedSchool != null) {
      setState(() {
        school = fetchedSchool;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appbarComponent(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 10.sp),
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    '📚 School & Class Overview',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 2.h),
                  SchoolInfoCard(
                    school: school,
                    className: widget.className,
                    section: widget.section,
                  ),

                  SizedBox(height: 3.h),
                  _buildStudentPortalCard(context, colorScheme),
                  SizedBox(height: 4.h),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.support_agent,
                          size: 20.sp,
                          color: colorScheme.secondary,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          contactInfo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.secondary),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          copyright,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      elevation: 5,
      shadowColor: colorScheme.primary.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
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
                  'School & Class Info',
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
                _infoRow(Icons.domain, 'School Name', school.schoolName),
                _infoRow(Icons.code, 'School Code', '${school.schoolCode}'),
                _infoRow(Icons.class_, 'Class', widget.className),
                _infoRow(Icons.group, 'Section', widget.section),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentPortalCard(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Card(
      color: colorScheme.surface,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      child: ExpansionTile(
        leading: Icon(Icons.school_rounded, color: colorScheme.primary),
        title: Text(
          'Student Portal',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.secondary,
          ),
        ),
        children: [
          ListTile(
            leading: Icon(Icons.person_add, color: colorScheme.secondary),
            title: const Text('Add Student Information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailScreen(
                    className: widget.className,
                    section: widget.section,
                    school: school,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: colorScheme.primary),
            title: const Text('View Students'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewStudentsPage(
                    school: school,
                    className: widget.className,
                    section: widget.section,
                  ),
                ),
              );
            },
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
          Expanded(
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
