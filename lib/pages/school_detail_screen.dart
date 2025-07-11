import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';

class SchoolDetailScreen extends StatelessWidget {
  final School school;

  const SchoolDetailScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF26A69A);
    final cardColor = const Color(0xFFD0ECE7);

    return Scaffold(
      appBar: AppBar(title: Text(school.schoolName)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _infoRow('School Code', '${school.schoolCode}'),
                _infoRow('Type', school.schoolType),
                _infoRow('Principal', school.principalName),
                _infoRow('Phone', school.phone1),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Classes & Sections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (school.classes!.isEmpty)
                  const Text('No classes added.')
                else
                  ...school.classes!.map((className) {
                    final sections = school.classSections![className] ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class: $className',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Wrap(
                            spacing: 8,
                            children: sections
                                .map(
                                  (s) => Chip(
                                    label: Text(s),
                                    backgroundColor: primaryColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
