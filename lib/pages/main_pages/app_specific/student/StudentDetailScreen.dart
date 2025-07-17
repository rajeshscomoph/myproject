import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class StudentDetailScreen extends StatefulWidget {
  final String className;
  final String section;
  final School school;

  const StudentDetailScreen({
    super.key,
    required this.className,
    required this.section,
    required this.school,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController enrollNoController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController examinationController = TextEditingController();
  final TextEditingController wearGlassController = TextEditingController();
  final TextEditingController contactLensController = TextEditingController();
  final TextEditingController cutoffUVA1Controller = TextEditingController();
  final TextEditingController cutoffUVA2Controller = TextEditingController();
  final TextEditingController eyeTestController = TextEditingController();
  final TextEditingController referredController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> _selectDateOfBirth() async {
    DateTime initialDate = DateTime.now().subtract(
      const Duration(days: 365 * 10),
    );
    DateTime firstDate = DateTime(1950);
    DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dobController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Students of - ${widget.className} ${widget.section}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(enrollNoController, 'Enroll No'),
              _buildTextField(rollNoController, 'Roll No'),
              _buildTextField(nameController, 'Student Name'),
              _buildTextField(sexController, 'Sex'),
              _buildDateField(dobController, 'Date of Birth'),
              _buildTextField(examinationController, 'Examination'),
              _buildTextField(wearGlassController, 'Wear Glass'),
              _buildTextField(contactLensController, 'Contact Lens'),
              _buildTextField(cutoffUVA1Controller, 'Cutoff UVA1'),
              _buildTextField(cutoffUVA2Controller, 'Cutoff UVA2'),
              _buildTextField(eyeTestController, 'Eye Test'),
              _buildTextField(referredController, 'Referred'),
              _buildTextField(phoneController, 'Phone'),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle save logic here
                    print('Student saved');
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: _selectDateOfBirth,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
}
