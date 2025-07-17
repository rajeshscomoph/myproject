import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewStudentsPage extends StatefulWidget {
  final School school;
  final String className;
  final String section;

  const ViewStudentsPage({
    super.key,
    required this.school,
    required this.className,
    required this.section,
  });

  @override
  State<ViewStudentsPage> createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {
  final IsarService _isarService = IsarService();
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _loadStudents();
  }

Future<List<Student>> _loadStudents() async {
    final db = await _isarService.db;
    final students = await db.students.where().findAll();

    return students
        .where(
          (student) =>
              student.school.value?.schoolCode == widget.school.schoolCode &&
              student.className == widget.className &&
              student.section == widget.section,
        )
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students: ${widget.className} ${widget.section}'),
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading students'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          } else {
            final students = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(12.sp),
              itemCount: students.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('Roll No: ${student.rollNumber}'),
                  onTap: () {
                    // optional: open detail page
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
