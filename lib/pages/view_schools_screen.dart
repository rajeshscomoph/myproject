import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'school_detail_screen.dart';

class ViewSchoolsScreen extends StatelessWidget {
  final IsarService isarService;

  const ViewSchoolsScreen({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Schools')),
      body: FutureBuilder<List<School>>(
        future: isarService.getAllSchools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schools saved.'));
          }

          final schools = snapshot.data!;
          return ListView.builder(
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final s = schools[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 16.w),
                child: ListTile(
                  title: Text('${s.schoolName} (${s.schoolType})'),
                  subtitle: Text(
                    'Principal Name: ${s.principalName}\n School Phone No.: ${s.phone1}',
                  ),
                  trailing: Text('Code: ${s.schoolCode}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchoolDetailScreen(school: s),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
