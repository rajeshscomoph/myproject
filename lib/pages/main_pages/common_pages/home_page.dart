import 'package:flutter/material.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/pages/add_school_screen.dart';
import 'package:myproject/pages/view_schools_screen.dart';
import '../../utility_pages/settings_page.dart';
import '../../utility_pages/privacy_page.dart';
import '../../utility_pages/about_us_page.dart';
import '../../utility_pages/terms_page.dart';

class HomePage extends StatelessWidget {
  final IsarService isarService;
  final String username = "Dr. Sharma";

  const HomePage({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        toolbarHeight: 8.h,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.sp),
          children: [
            SizedBox(height: 1.h),

            // Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.sp),
                child: Image.asset(
                  'assets/logos/logo.jpg',
                  width: 46.sw,
                  height: 22.sh,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Welcome message
            Center(
              child: Text(
                'Welcome, $username!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(height: 1.h),
            Center(
              child: Text(
                'Explore your dashboard below',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 2.h),

            // School dropdown
            Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              child: ExpansionTile(
                leading: Icon(Icons.school, color: colorScheme.primary),
                title: Text(
                  'School Screening Program',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.add, color: colorScheme.secondary),
                    title: const Text('Add School Information'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddSchoolScreen(isarService: isarService),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list, color: colorScheme.primary),
                    title: const Text('View Schools'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ViewSchoolsScreen(isarService: isarService),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // App Settings & Info dropdown
            Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 3.h),
              child: ExpansionTile(
                leading: Icon(Icons.settings, color: colorScheme.secondary),
                title: Text(
                  'App Settings & Info',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.settings, color: colorScheme.primary),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.privacy_tip,
                      color: colorScheme.primary,
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
                    leading: Icon(Icons.info, color: colorScheme.primary),
                    title: const Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.description,
                      color: colorScheme.primary,
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
