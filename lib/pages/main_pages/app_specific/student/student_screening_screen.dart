import 'package:flutter/material.dart';
import 'package:myproject/components/Student_Info_Card.dart';
import 'package:myproject/components/School_Info_Card.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/pages/main_pages/app_specific/student/HomePageStudent.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentScreeningScreen extends StatefulWidget {
  final Student student;
  final IsarService isarService;
  final dynamic school;

  const StudentScreeningScreen({
    super.key,
    required this.student,
    required this.isarService,
    required this.school,
  });

  @override
  State<StudentScreeningScreen> createState() => _StudentScreeningScreenState();
}

class _StudentScreeningScreenState extends State<StudentScreeningScreen> {
  String? wearGlass, contactLens, cutoffUVA1, cutoffUVA2, eyeTest, referred;
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final options = {
    'yesno': ['Yes', 'No'],
    'cutoff': ['Can read 6/9', "Can't read 6/9"],
    'eyeTest': [
      'Never',
      'Within last 1 year',
      'During last 1-2 years',
      'Beyond 2 years',
      'Don’t Know',
    ],
    'referred': [
      'Yes, as child uses glasses/ Contact Lens',
      'Yes Unaided Vision <6/9 in any eye',
      'Not Referred',
      'Control Case',
    ],
  };

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    wearGlass = s.wearGlass;
    contactLens = s.contactLens;
    cutoffUVA1 = s.cutoffUVA1;
    cutoffUVA2 = s.cutoffUVA2;
    eyeTest = s.eyeTest;
    referred = s.referred;
    phoneController.text = s.phone;
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    final s = widget.student
      ..wearGlass = wearGlass ?? ''
      ..contactLens = contactLens ?? ''
      ..cutoffUVA1 = cutoffUVA1 ?? ''
      ..cutoffUVA2 = cutoffUVA2 ?? ''
      ..eyeTest = eyeTest ?? ''
      ..referred = referred ?? ''
      ..phone = phoneController.text.trim();

    await widget.isarService.addOrUpdateStudent(s);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Student saved")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePageAfterSection(
          schoolCode: widget.school.schoolCode,
          className: widget.student.className,
          section: widget.student.section,
          isarService: widget.isarService,
        ),
      ),
    );
  }

  Widget _buildChips(
    String title,
    List<String> choices,
    String? selected,
    void Function(String) onSelect,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: choices.map((o) {
              return ChoiceChip(
                label: Text(o),
                selected: selected == o,
                onSelected: (_) => setState(() => onSelect(o)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarComponent(context),
      body: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SchoolInfoCard(
                school: widget.school,
                className: widget.student.className,
                section: widget.student.section,
              ),
              SizedBox(height: 2.h),
              StudentInfoCard(student: widget.student),
              SizedBox(height: 2.h),

              _buildChips(
                "Wearing Glasses",
                options['yesno']!,
                wearGlass,
                (v) => wearGlass = v,
              ),
              _buildChips(
                "Contact Lens",
                options['yesno']!,
                contactLens,
                (v) => contactLens = v,
              ),
              _buildChips(
                "Cutoff UVA1",
                options['cutoff']!,
                cutoffUVA1,
                (v) => cutoffUVA1 = v,
              ),
              _buildChips(
                "Cutoff UVA2",
                options['cutoff']!,
                cutoffUVA2,
                (v) => cutoffUVA2 = v,
              ),
              _buildChips(
                "Eye Test",
                options['eyeTest']!,
                eyeTest,
                (v) => eyeTest = v,
              ),
              _buildChips(
                "Referred Reason",
                options['referred']!,
                referred,
                (v) => referred = v,
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final phone = value?.trim() ?? '';
                    if (phone.isEmpty) return 'Phone number is required';
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
              ),

              ElevatedButton.icon(
                onPressed: _saveStudent,
                icon: const Icon(Icons.save),
                label: const Text("Save Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
