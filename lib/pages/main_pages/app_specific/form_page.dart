import 'package:flutter/material.dart';
import 'package:myproject/components/PEC/primary_eye_care_first_page.dart';

class FormPage extends StatelessWidget {
  final String title;
  final Widget? child; // make it nullable so we can build default if null

  FormPage({super.key, this.title = 'Primary Eye Care Services', this.child});

  // Create form key here so it's available to default child
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        // If child is not passed, build PrimaryEyeCareFirstPage with formKey
        child: child ?? PrimaryEyeCareFirstPage(formKey: formKey),
      ),
    );
  }
}
