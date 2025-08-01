import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/pages/main_pages/app_specific/student/add_StudentDetail.dart';
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

  final List<String> _examinationOptions = ['All', 'Examined', 'Absent', 'Refused'];
  String _selectedExamination = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];

  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  @override
  void initState() {
    super.initState();
    _loadSchool();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _loadSchool() async {
    final fetchedSchool = await widget.isarService.getSchoolByCode(widget.schoolCode);
    if (fetchedSchool != null) {
      setState(() {
        school = fetchedSchool;
        isLoading = false;
      });
      _loadStudents();
    }
  }

  Future<void> _loadStudents() async {
    final db = await widget.isarService.db;
    final students = await db.students.where().findAll();

    setState(() {
      _allStudents = students
          .where((s) =>
              s.school.value?.schoolCode == widget.schoolCode &&
              s.className == widget.className &&
              s.section == widget.section)
          .toList();
    });

    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final matchesSearch = student.name.toLowerCase().contains(query) ||
            student.rollNumber.toString().contains(query);
        final matchesExam = _selectedExamination == 'All' ||
            student.examination == _selectedExamination;
        return matchesSearch && matchesExam;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  _buildStudentActions(context, colorScheme),
                  SizedBox(height: 4.h),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.support_agent, size: 20.sp, color: colorScheme.secondary),
                        SizedBox(height: 1.h),
                        Text(contactInfo,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: colorScheme.secondary),
                            textAlign: TextAlign.center),
                        SizedBox(height: 1.h),
                        Text(
                          copyright,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
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

  Widget _buildStudentActions(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDetailScreen(
                  className: widget.className,
                  section: widget.section,
                  school: school,
                  isarService: widget.isarService,
                ),
              ),
            );
            await _loadStudents(); // Refresh after return
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Add Student'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.sp),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            hintText: 'Search by name or roll number',
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 8.sp,
          children: _examinationOptions.map((status) {
            final isSelected = _selectedExamination == status;
            final icon = status == 'Examined'
                ? Icons.check_circle
                : status == 'Absent'
                    ? Icons.cancel
                    : status == 'Refused'
                        ? Icons.block
                        : Icons.list;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: isSelected ? Colors.white : null),
                  const SizedBox(width: 4),
                  Text(status),
                ],
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedExamination = status;
                  _applyFilters();
                });
              },
              selectedColor: colorScheme.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
            );
          }).toList(),
        ),
        SizedBox(height: 2.h),
        if (_filteredStudents.isEmpty)
          const Text('No matching students found.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredStudents.length,
            itemBuilder: (context, index) {
              final student = _filteredStudents[index];
              return Card(
                child: ListTile(
                  title: Text(student.name),
                  subtitle: Text('Roll No: ${student.rollNumber}'),
                  trailing: Text('Status: ${student.examination}'),
                ),
              );
            },
          ),
      ],
    );
  }
}
