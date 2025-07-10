import 'package:flutter/material.dart';
import 'package:myproject/components/PEC/primary_eye_care_first_page.dart';

class FormPage extends StatelessWidget {
  final String title;
  final Widget? child; // optional child widget

  const FormPage({
    super.key,
    this.title = 'Primary Eye Care Services',
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Use passed child if provided, else show default PrimaryEyeCareFirstPage
        child: child ?? const PrimaryEyeCareFirstPage(),
      ),
    );
  }
}
