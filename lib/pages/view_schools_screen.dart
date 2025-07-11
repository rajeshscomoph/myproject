import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/school.dart';
import 'school_detail_screen.dart';

class ViewSchoolsScreen extends StatelessWidget {
  final AppDatabase db;

  const ViewSchoolsScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Schools')),
      body: FutureBuilder<List<School>>(
        future: db.getAllSchools(),
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
                child: ListTile(
                  title: Text('${s.schoolName} (${s.schoolType})'),
                  subtitle: Text(
                    'Principal: ${s.principalName}\nPhone: ${s.phone1}',
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
