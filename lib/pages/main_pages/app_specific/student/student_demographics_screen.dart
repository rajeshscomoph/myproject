import 'package:enum_to_string/camel_case_to_words.dart';
import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/choice_chip_field_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:myproject/config.dart';
import 'package:myproject/models/school.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:myproject/pages/main_pages/app_specific/student/student_screening_screen.dart';

class StudentDemographicScreen extends StatefulWidget {
  final String className;
  final String section;
  final School school;
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
  ExaminationStatus? selectedExamination;
  DateTime? dob;
  bool showGenderError = false;
  bool showExamError = false;
  bool showDobError = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];

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
      selectedExamination = ExaminationStatusExtension.fromString( s.examination);
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
    ),
  );

  Future<Student?> _saveStudentLocally() async {
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
      return null;
    }

    final student = widget.existingStudent ?? Student();

    if (widget.existingStudent != null) {
      student.id = widget.existingStudent!.id;
    }

    student
      ..name = nameController.text.trim()
      ..enrollNo = enrollNoController.text.trim()
      ..rollNumber = int.tryParse(rollNumberController.text.trim()) ?? 0
      ..gender = selectedGender!
      ..dob = dob!
      ..examination = selectedExamination!.label
      ..school.value = widget.school
      ..className = widget.className
      ..section = widget.section
      ..schoolCode = '${widget.school.schoolCode}'
      ;

    await widget.isarService.addOrUpdateStudent(student);
    return student;
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
              ChoiceChipFieldComponent<String>(
                label: 'Gender',
                options: _genders,
                selected: selectedGender,
                onSelected: (val) {
                  setState(() {
                    selectedGender = val;
                    showGenderError = false;
                  });
                },
                labelBuilder: (val) => val,
              ),
              if (showGenderError)
                const Text(
                  'Please select gender',
                  style: TextStyle(color: Colors.red),
                ),
              _buildLabel('Date of Birth'),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
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
              ChoiceChipFieldComponent<ExaminationStatus>(
                label: 'Examination',
                options: ExaminationStatus.values,
                selected: selectedExamination,
                onSelected: (val) {
                  setState(() {
                    selectedExamination = val;
                    showExamError = false;
                  });
                }, labelBuilder: (val) => val.label,
              ),
              if (showExamError)
                const Text(
                  'Please select examination status',
                  style: TextStyle(color: Colors.red),
                ),

              /// 👉 Proceed to Screening
              if (selectedExamination == ExaminationStatus.examined)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Proceed to Screening"),
                    onPressed: () async {
                      final savedStudent = await _saveStudentLocally();
                      if (savedStudent != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentScreeningScreen(
                              student: savedStudent,
                              isarService: widget.isarService,
                              school: widget.school,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Student'),
                onPressed: () async {
                  final saved = await _saveStudentLocally();
                  if (saved != null) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
