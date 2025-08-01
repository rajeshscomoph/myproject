// student_demographic_screen.dart
import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:myproject/pages/main_pages/app_specific/student/student_screening_screen.dart';

class StudentDemographicScreen extends StatefulWidget {
  final String className;
  final String section;
  final dynamic school;
  final IsarService isarService;
 final Student? existingStudent;
  const StudentDemographicScreen({
    super.key,
    required this.className,
    required this.section,
    required this.school,
    required this.isarService,
    this.existingStudent,
  });

  @override
  State<StudentDemographicScreen> createState() =>
      _StudentDemographicScreenState();
}




class _StudentDemographicScreenState extends State<StudentDemographicScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final enrollNoController = TextEditingController();
  final rollNumberController = TextEditingController();
  String? selectedGender;
  String? selectedExamination;
  DateTime? dob;
   bool showGenderError = false;
  bool showExamError = false;
  bool showDobError = false;


  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _examinations = ['Examined', 'Absent', 'Refused'];

@override
  void initState() {
    super.initState();
    final s = widget.existingStudent;
    if (s != null) {
      nameController.text = s.name;
      enrollNoController.text = s.enrollNo;
      rollNumberController.text = s.rollNumber.toString();
      selectedGender = s.gender;
      dob = s.dob;
      selectedExamination = s.examination;
    }
  }
  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
    ),
  );

  Future<void> _saveStudent() async {
    final isValid = _formKey.currentState!.validate();
    setState(() {
      showDobError = dob == null;
      showGenderError = selectedGender == null;
      showExamError = selectedExamination == null;
    });

    if (!isValid ||
        dob == null ||
        selectedGender == null ||
        selectedExamination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }
final student = widget.existingStudent ?? Student();
    Student()
      ..name = nameController.text.trim()
      ..enrollNo = enrollNoController.text.trim()
      ..rollNumber = int.tryParse(rollNumberController.text.trim()) ?? 0
      ..gender = selectedGender!
      ..dob = dob!
      ..examination = selectedExamination!
      ..school.value = widget.school
      ..schoolCode = widget.school.schoolCode
      ..className = widget.className
      ..section = widget.section;

    await widget.isarService.addOrUpdateStudent(student);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Student added successfully")));

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  Widget _buildChoiceChipField({
    required String label,
    required List<String> options,
    required String? selected,
    required void Function(String) onSelected,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
          ),
          SizedBox(height: 0.5.h),
          Wrap(
            spacing: 8.sp,
            children: options.map((option) {
              final isSelected = selected == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) => setState(() => onSelected(option)),
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(color: isSelected ? Colors.white : null),
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
        padding: EdgeInsets.all(14.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SchoolInfoCard(
                school: widget.school,
                className: widget.className,
                section: widget.section,
              ),
              SizedBox(height: 0.5.h),

              _buildLabel('Student Name'),
              TextFormField(
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),

              _buildLabel('Enrollment Number'),
              TextFormField(
                controller: enrollNoController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter enrollment number' : null,
              ),

              _buildLabel('Roll Number'),
              TextFormField(
                controller: rollNumberController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter roll number' : null,
              ),

              _buildChoiceChipField(
                label: 'Gender',
                options: _genders,
                selected: selectedGender,
                onSelected: (val) {
                  setState(() {
                    selectedGender = val;
                    showGenderError = false;
                  });
                },
              ),
              if (showGenderError)
                const Text('Please select gender',
                    style: TextStyle(color: Colors.red)),

              _buildLabel('Date of Birth'),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12.sp),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 10.sp,
                    ),
                  ),
                  child: Text(
                    dob != null
                        ? '${dob!.day.toString().padLeft(2, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.year}'
                        : 'Tap to select date',
                  ),
                ),
              ),
              if (showDobError)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Please select date of birth',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: 1.h),

              _buildChoiceChipField(
                label: 'Examination',
                options: _examinations,
                selected: selectedExamination,
                onSelected: (val) {
                  setState(() {
                    selectedExamination = val;
                    showExamError = false;
                  });
                },
              ),
              if (showExamError)
                const Text('Please select examination status',
                    style: TextStyle(color: Colors.red)),

              /// 👓 Screening route
              if (selectedExamination?.toLowerCase() == 'examined')
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Proceed to Screening"),
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      setState(() {
                        showDobError = dob == null;
                        showGenderError = selectedGender == null;
                        showExamError = selectedExamination == null;
                      });

                      if (!isValid || dob == null || selectedGender == null || selectedExamination == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please complete all fields.")),
                        );
                        return;
                      }

                      final student = Student()
                        ..name = nameController.text.trim()
                        ..enrollNo = enrollNoController.text.trim()
                        ..rollNumber = int.tryParse(rollNumberController.text.trim()) ?? 0
                        ..gender = selectedGender ?? ''
                        ..dob = dob ?? DateTime(2010)
                        ..examination = selectedExamination ?? ''
                        ..school.value = widget.school
                        ..schoolCode = widget.school.schoolCode
                        ..className = widget.className
                        ..section = widget.section
                        ..wearGlass = ''
                        ..contactLens = ''
                        ..cutoffUVA1 = ''
                        ..cutoffUVA2 = ''
                        ..eyeTest = ''
                        ..referred = ''
                        ..phone = '';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentScreeningScreen(
                            student: student,
                            isarService: widget.isarService,
                            school: widget.school,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: 3.h),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Student'),
                onPressed: _saveStudent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

