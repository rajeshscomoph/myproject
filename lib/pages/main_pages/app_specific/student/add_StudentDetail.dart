import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
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
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? sex;
  String? examination;
  String? wearGlass;
  String? contactLens;
  String? cutoffUVA1;
  String? cutoffUVA2;
  String? eyeTest;
  String? referred;

  final List<String> _sexOptions = ['Male', 'Female', 'Other'];
  final List<String> _examinationOptions = ['Examined', 'Absent', 'Refused'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _cutoffOptions = ['Can read 6/9', "Can't read 6/9"];
  final List<String> _eyeTestOptions = [
    'Never',
    'Within last 1 year',
    'During last 1-2 years',
    'Beyond 2 years',
    'Don’t Know',
  ];
  final List<String> _referredOptions = [
    'Yes, as child uses glasses/ Contact Lens',
    'Yes Unaided Vision <6/9 in any eye',
    'Not Referred',
    'Control Case',
  ];

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 0.5.h, top: 1.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appbarComponent(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colorScheme),
                _buildLabel('Enrollment No'),
                _buildTextField(enrollNoController, ''),
                _buildLabel('Roll Number'),
                _buildTextField(rollNoController, ''),
                _buildLabel('Student Name'),
                _buildTextField(nameController, ''),

                _buildChipsGroup(
                  'Gender',
                  _sexOptions,
                  sex,
                  (val) => setState(() => sex = val),
                ),

                _buildLabel('Date of Birth'),
                _buildDateField(dobController, ''),

                _buildChipsGroup(
                  'Examination',
                  _examinationOptions,
                  examination,
                  (val) => setState(() => examination = val),
                ),
                _buildChipsGroup(
                  'Wear Glass',
                  _yesNoOptions,
                  wearGlass,
                  (val) => setState(() => wearGlass = val),
                ),
                _buildChipsGroup(
                  'Contact Lens',
                  _yesNoOptions,
                  contactLens,
                  (val) => setState(() => contactLens = val),
                ),

                _buildChipsGroup(
                  'Cutoff UVA1',
                  _cutoffOptions,
                  cutoffUVA1,
                  (val) => setState(() => cutoffUVA1 = val),
                ),
                _buildChipsGroup(
                  'Cutoff UVA2',
                  _cutoffOptions,
                  cutoffUVA2,
                  (val) => setState(() => cutoffUVA2 = val),
                ),

                _buildChipsGroup(
                  'Eye Test',
                  _eyeTestOptions,
                  eyeTest,
                  (val) => setState(() => eyeTest = val),
                ),
                _buildChipsGroup(
                  'Referred',
                  _referredOptions,
                  referred,
                  (val) => setState(() => referred = val),
                ),

                // ✅ Phone number with validation
                _buildTextField(
                  phoneController,
                  'Phone Number',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Phone Number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: _saveStudent,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate() &&
        sex != null &&
        examination != null &&
        wearGlass != null &&
        contactLens != null &&
        cutoffUVA1 != null &&
        cutoffUVA2 != null &&
        eyeTest != null &&
        referred != null) {
      print('Student saved');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0.5.h),
        SchoolInfoCard(
          school: widget.school,
          className: widget.className,
          section: widget.section,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: label.toLowerCase().contains('phone')
            ? TextInputType.phone
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator:
            validator ??
            (value) =>
                (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _selectDateOfBirth,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

          suffixIcon: const Icon(Icons.calendar_today),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildChipsGroup(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String) onSelected,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.5.h),
          Wrap(
            spacing: 8,
            runSpacing: -8,
            children: options.map((option) {
              final bool selected = option == selectedValue;
              return ChoiceChip(
                label: Text(option),
                selected: selected,
                onSelected: (_) => onSelected(option),
                labelStyle: TextStyle(fontSize: 15.sp),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
