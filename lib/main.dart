import 'package:flutter/material.dart';
import 'package:myproject/pages/main_pages/common_pages/login_page.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF26A69A),
        primarySwatch: Colors.blue,
     
       ),
      home: const LoginPage(),
    );
  }
}