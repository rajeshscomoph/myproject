import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/app_theme.dart';
import 'package:myproject/config.dart';
import 'package:myproject/pages/main_pages/common_pages/login_page.dart';
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
          // ⬇ Replace LoginPage with HomePage, passing service (or keep LoginPage if you want login first)
          home: LoginPage(isarService: isarService),
        );
      },
    );
  }
}
