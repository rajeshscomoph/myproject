import 'package:animated_text_kit/animated_text_kit.dart';
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
  final String username = "R. Sharma";
  final String organizationName = "Community Ophthalmology";
  final String appName = "School Screening Program";
  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  const HomePage({super.key, required this.isarService});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String greeting = _getGreeting();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 8.h,
        centerTitle: false,
        titleSpacing: 2.w,
        title: Row(
          children: [
            Image.asset(
              'assets/logos/appLogo.png',
              height: 6.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                appName,
                style: TextStyle(
                  color: colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.sp, 10.sp, 16.sp, 10.sp),
          children: [
            SizedBox(height: 1.h),

            // Greeting & username
            Text(
              "$greeting,",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "$username!",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 1.h),

            // Motivational subtitle
            Text(
              "Together, let’s safeguard every child’s vision.",
              // Or pick any of these:
              // "Empowering teams to protect young eyes, one screening at a time."
              // "Striving for clearer futures through dedicated vision care."
              // "Your expertise makes healthy vision possible for every child."
              // "Collaborating for better sight and brighter futures."
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colorScheme.secondary),
            ),

            SizedBox(height: 2.h),

          // Organization logo & details
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.sp),
                  child: Image.asset(
                    'assets/logos/logo.png',
                    width: 18.w,
                    height: 9.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organizationName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Dr. R.P. Centre for Ophthalmology",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "AIIMS, New Delhi",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Motto / tagline animated
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Better",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: colorScheme.secondary,
                  ),
                ),
                SizedBox(
                  height: 30.sp,
                  width: 44.sp,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        RotateAnimatedText('VISION'),
                        RotateAnimatedText('CARE'),
                        RotateAnimatedText('IMPACT'),
                      ],
                    ),
                  ),
                ),
                Text(
                  "for every child.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Short description
            Text(
              "Welcome to the $appName. Here you can manage and explore all school health screening activities with ease.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),

            // School dropdown card
            Card(
              color: colorScheme.surface,
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
              shadowColor: colorScheme.primary.withOpacity(0.2),
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

            // App settings card
            Card(
              color: colorScheme.surface,
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
              shadowColor: colorScheme.primary.withOpacity(0.2),
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

            // Contact info & footer
            SizedBox(height: 2.h),
            Center(
              child: Text(
                contactInfo,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 1.h),
            Center(
              child: Text(
                copyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
