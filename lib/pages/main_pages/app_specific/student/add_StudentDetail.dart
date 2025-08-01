import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myproject/config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';

class StudentDetailScreen extends StatefulWidget {
  final String className, section;
  final School school;
  final IsarService isarService;
  final Student? existingStudent;

  const StudentDetailScreen({
    super.key,
    required this.className,
    required this.section,
    required this.school,
    required this.isarService,
    this.existingStudent,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

Widget _buildLabel(String text) => Padding(
  padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
  child: Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
  ),
);

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final enrollNoController = TextEditingController();
  final rollNoController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final FocusNode enrollFocus = FocusNode();

  String? sex,
      examination,
      wearGlass,
      contactLens,
      cutoffUVA1,
      cutoffUVA2,
      eyeTest,
      referred;

  final options = {
    'sex': ['Male', 'Female', 'Other'],
    'exam': ['Examined', 'Absent', 'Refused'],
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

    final s = widget.existingStudent;
    if (s != null) {
      enrollNoController.text = s.enrollNo;
      rollNoController.text = s.rollNumber.toString();
      nameController.text = s.name;
      dobController.text = DateFormat('dd-MM-yyyy').format(s.dob);
      phoneController.text = s.phone;

      sex = s.gender;
      examination = s.examination;
      wearGlass = s.wearGlass;
      contactLens = s.contactLens;
      cutoffUVA1 = s.cutoffUVA1;
      cutoffUVA2 = s.cutoffUVA2;
      eyeTest = s.eyeTest;
      referred = s.referred;
    }
  }

  Future<void> _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  void _resetForm() {
    enrollNoController.clear();
    rollNoController.clear();
    nameController.clear();
    dobController.clear();
    phoneController.clear();
    setState(() {
      sex = null;
      examination = null;
      wearGlass = null;
      contactLens = null;
      cutoffUVA1 = null;
      cutoffUVA2 = null;
      eyeTest = null;
      referred = null;
    });
    FocusScope.of(context).requestFocus(enrollFocus);
  }

  Future<void> _saveStudent() async {
    final isMinimalValid =
        enrollNoController.text.isNotEmpty &&
        rollNoController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        sex != null &&
        examination != null;

    if (examination != 'Examined') {
      if (isMinimalValid) {
        await _confirmSaveAndSubmit(
          'Student not examined. Save basic info?',
          basic: true,
        );
      } else {
        _showMsg('Please fill Enrollment, Name, Roll Number, Gender & Examination');
      }
      return;
    }

    if (_formKey.currentState!.validate() &&
        [
          sex,
          wearGlass,
          contactLens,
          cutoffUVA1,
          cutoffUVA2,
          eyeTest,
          referred,
        ].every((v) => v != null)) {
      await _confirmSaveAndSubmit(
        'All student details will be saved. Proceed?',
      );
    } else {
      final missing = {
        'Gender': sex,
        'Wear Glass': wearGlass,
        'Contact Lens': contactLens,
        'Cutoff UVA1': cutoffUVA1,
        'Cutoff UVA2': cutoffUVA2,
        'Eye Test': eyeTest,
        'Referred': referred,
      }.entries.where((e) => e.value == null).map((e) => e.key).join(', ');
      _showMsg('Missing fields: $missing');

    }
  }

  Future<void> _storeStudent({bool basic = false}) async {
    final student = widget.existingStudent ?? Student();
     student 
      ..enrollNo = enrollNoController.text.trim()
      ..rollNumber = int.tryParse(rollNoController.text.trim()) ?? 0
      ..name = nameController.text.trim()
      ..gender = sex ?? ''
      ..dob = DateFormat('dd-MM-yyyy').parse(dobController.text.trim())
      ..examination = examination ?? ''
      ..className = widget.className
      ..section = widget.section
      ..school.value = widget.school; // ✅ Important: link the school

    if (!basic) {
      student
        ..wearGlass = wearGlass!
        ..contactLens = contactLens!
        ..cutoffUVA1 = cutoffUVA1!
        ..cutoffUVA2 = cutoffUVA2!
        ..eyeTest = eyeTest!
        ..referred = referred!
        ..phone = phoneController.text.trim();
    } else {
      // If not examined, initialize optional fields with empty string to prevent Isar crash
      student
        ..wearGlass = ''
        ..contactLens = ''
        ..cutoffUVA1 = ''
        ..cutoffUVA2 = ''
        ..eyeTest = ''
        ..referred = ''
        ..phone = '';
    }
    
    await widget.isarService.addOrUpdateStudent(student);
       _showMsg('Student saved successfully');
  }

 Future<void> _confirmSaveAndSubmit(String msg, {bool basic = false}) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Save'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // ❌ Cancel => false
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storeStudent(basic: basic); // ✅ Save student
              Navigator.of(context).pop(true); // ✅ Submit => true
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );


    if (result == true) {
      // User confirmed and student was saved
      config.logger.d("pop successfull");
      _resetForm(); // or Navigator.pop(), etc.
      config.logger.d("Value set");
    }


  }

  void _showMsg(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: appbarComponent(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SchoolInfoCard(
                school: widget.school,
                className: widget.className,
                section: widget.section,
              ),
              _buildLabel('Enrollment Number'),
               _buildField('', enrollNoController, focusNode: enrollFocus),
              _buildLabel('Roll Number'),
              _buildField( '',
                rollNoController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              _buildLabel('Student Name'),
              _buildField('', nameController),
              _buildChips(
                'Gender',
                options['sex']!,
                sex,
                (val) => setState(() => sex = val),
              ),
              _buildLabel('Date of Birth'),
              _buildDateField('', dobController),
              _buildChips('Examination', options['exam']!, examination, (val) {
                setState(() {
                  examination = val;
                  if (val != 'Examined') {
                    wearGlass = '';
                    contactLens = '';
                    cutoffUVA1 = '';
                    cutoffUVA2 = '';
                    eyeTest = '';
                    referred = '';
                    phoneController.clear();
                  }
                });
              }),
              if (examination == 'Examined') ...[
                _buildChips(
                  'Wear Glass',
                  options['yesno']!,
                  wearGlass,
                  (v) => setState(() => wearGlass = v),
                ),
                _buildChips(
                  'Contact Lens',
                  options['yesno']!,
                  contactLens,
                  (v) => setState(() => contactLens = v),
                ),
                _buildChips(
                  'Cutoff UVA1',
                  options['cutoff']!,
                  cutoffUVA1,
                  (v) => setState(() => cutoffUVA1 = v),
                ),
                _buildChips(
                  'Cutoff UVA2',
                  options['cutoff']!,
                  cutoffUVA2,
                  (v) => setState(() => cutoffUVA2 = v),
                ),
                _buildChips(
                  'Eye Test',
                  options['eyeTest']!,
                  eyeTest,
                  (v) => setState(() => eyeTest = v),
                ),
                _buildChips(
                  'Reason for Referred to Optometrist',
                  options['referred']!,
                  referred,
                  (v) => setState(() => referred = v),
                ),
                _buildLabel('Phone Number'),
                _buildField('',
                  phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter Phone Number';
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(v))
                      return 'Enter a valid 10-digit phone number';
                    return null;
                  },
                ),
              ],
              if (examination == 'Absent' || examination == 'Refused')
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Student not examined. Only basic info will be saved.',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                onPressed: _saveStudent,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: theme.primary,
                ),
                icon: const Icon(Icons.save),
                label: const Text('Save Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildField(
    String label,
    TextEditingController ctrl, {
    FocusNode? focusNode, // ADD THIS
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: ctrl,
        focusNode: focusNode, // ADD THIS
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator:
            validator ??
            (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: ctrl,
        readOnly: true,
        onTap: _selectDOB,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        validator: (v) =>
            (v == null || v.isEmpty) ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildChips(
    String title,
    List<String> options,
    String? selected,
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
            children: options
                .map(
                  (option) => ChoiceChip(
                    label: Text(option),
                    selected: selected == option,
                    onSelected: (_) => onSelected(option),
                    labelStyle: TextStyle(fontSize: 15.sp),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
