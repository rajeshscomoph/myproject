import 'package:flutter/material.dart';
import 'package:myproject/pages/main_pages/app_specific/form_page.dart';
import '../../utility_pages/settings_page.dart';
import '../../utility_pages/privacy_page.dart';
import '../../utility_pages/about_us_page.dart';
import '../../utility_pages/terms_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

            // Menu items
            buildMenuCard(
              context,
              icon: Icons.visibility,
              title: 'Primary Eye Care Services',
              page: const FormPage(),
            ),
            buildMenuCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              page: const SettingsPage(),
            ),
            buildMenuCard(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              page: const PrivacyPage(),
            ),
            buildMenuCard(
              context,
              icon: Icons.info,
              title: 'About Us',
              page: const AboutUsPage(),
            ),
            buildMenuCard(
              context,
              icon: Icons.description,
              title: 'Terms and Conditions',
              page: const TermsPage(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a rounded card containing a ListTile for navigation
  Widget buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
