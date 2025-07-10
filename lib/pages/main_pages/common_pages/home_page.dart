import 'package:flutter/material.dart';
import 'package:myproject/pages/add_school_screen.dart';
import 'package:myproject/pages/view_schools_screen.dart';
import 'package:myproject/services/DB/school.dart';
import '../../utility_pages/settings_page.dart';
import '../../utility_pages/privacy_page.dart';
import '../../utility_pages/about_us_page.dart';
import '../../utility_pages/terms_page.dart';

class HomePage extends StatelessWidget {
  final db = AppDatabase();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/logos/logo.jpg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Welcome message
            const Center(
              child: Text(
                'Welcome, Dr. Sharma!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Explore your dashboard below',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 32),

            // School dropdown
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                leading: const Icon(Icons.school, color: Colors.blueAccent),
                title: const Text('School Screening Program'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.blueAccent),
                    title: const Text('Add School'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddSchoolScreen(db: db, themeNotifier: null),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.blueAccent),
                    title: const Text('View Schools'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewSchoolsScreen(db: db),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // App Settings & Info dropdown
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                leading: const Icon(Icons.settings, color: Colors.blueAccent),
                title: const Text('App Settings & Info'),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blueAccent),
                    title: const Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TermsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
