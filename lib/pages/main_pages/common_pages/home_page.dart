import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/footer_info_component.dart';
import 'package:myproject/components/navigation_title_component.dart';
import 'package:myproject/components/organisation_header_component.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


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
      appBar: appbarComponent(context),
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
            OrganizationHeaderComponent(organizationName: organizationName),
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
                  NavigationTileComponent(
                    title: 'Add School Information',
                    icon: Icons.add,
                    routeName: '/add-school',
                    arguments: isarService, // Will be passed to onGenerateRoute
                  ),
                  NavigationTileComponent(
                    title: 'View Schools',
                    icon: Icons.list,
                    routeName: '/view-schools',
                    arguments: isarService, // Will be passed to onGenerateRoute
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
                children: const [
                  NavigationTileComponent(
                    icon: Icons.settings,
                    title: 'Settings',
                    routeName: '/settings',
                  ),
                  
                  NavigationTileComponent(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    routeName: '/privacy',
                  ),
                  NavigationTileComponent(
                    icon: Icons.info,
                    title: 'About Us',
                    routeName: '/about',
                  ),
                  NavigationTileComponent(
                    icon: Icons.description,
                    title: 'Terms and Conditions',
                    routeName: '/terms',
                  ),
                ],
              ),
            ),

            // Contact info & footer
            SizedBox(height: 2.h),
            FooterInfoComponent(
              contactInfo: contactInfo,
              copyright: copyright,
            ),
          ],
        ),
      ),
    );
  }
}
