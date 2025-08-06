import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/app_theme.dart';
import 'package:myproject/config.dart';
import 'package:myproject/pages/main_pages/app_specific/school/add_school_screen.dart';
import 'package:myproject/pages/main_pages/app_specific/school/view_schools_screen.dart';
import 'package:myproject/pages/main_pages/common_pages/login_page.dart';
import 'package:myproject/pages/utility_pages/about_us_page.dart';
import 'package:myproject/pages/utility_pages/privacy_page.dart';
import 'package:myproject/pages/utility_pages/settings_page.dart';
import 'package:myproject/pages/utility_pages/terms_page.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:myproject/services/logs/log_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await LogManager().init();

  // Initialize Isar service
  final isarService = IsarService();
  config = await Config.load();

  await LogManager.writeDeviceAndAppInfo(config.logger);


  config.logger.i("Starting the app");
  runApp(MyApp(isarService: isarService));
}

class MyApp extends StatelessWidget {
  final IsarService isarService;

  const MyApp({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Login Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/add-school') {
              final isarService = settings.arguments as IsarService;
              return MaterialPageRoute(
                builder: (_) => AddSchoolScreen(isarService: isarService),
              );
            }

            if (settings.name == '/view-schools') {
              final isarService = settings.arguments as IsarService;
              return MaterialPageRoute(
                builder: (_) => ViewSchoolsScreen(isarService: isarService),
              );
            }

            if (settings.name == '/settings') {
              return MaterialPageRoute(builder: (_) => const SettingsPage());
            }
            if (settings.name == '/privacy') {
              return MaterialPageRoute(builder: (_) => const PrivacyPage());
            }
            if (settings.name == '/about') {
              return MaterialPageRoute(builder: (_) => const AboutUsPage());
            }
            if (settings.name == '/terms') {
              return MaterialPageRoute(builder: (_) => const TermsPage());
            }


            // Define other named routes here if needed
            return null;
          },
          // ⬇ Replace LoginPage with HomePage, passing service (or keep LoginPage if you want login first)
          home: LoginPage(isarService: isarService),
        );
      },
    );
  }
}
