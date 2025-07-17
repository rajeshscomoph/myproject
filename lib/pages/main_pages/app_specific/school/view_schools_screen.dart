import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'school_detail_screen.dart';

class ViewSchoolsScreen extends StatelessWidget {
  final IsarService isarService;
  final String appName = "School Screening Program";

  const ViewSchoolsScreen({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appbarComponent(context), 
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
                margin: EdgeInsets.fromLTRB(10.sp, 8.sp, 10.sp, 8.sp),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        s.schoolName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('(${s.schoolType})'),
                    ],
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Principal Name: ${s.principalName}'),
                      Text('Phone No: ${s.phone1}'),
                    ],
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
