// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddSchoolScreen extends StatefulWidget {
  final IsarService isarService;

  const AddSchoolScreen({super.key, required this.isarService});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  final _formKey = GlobalKey<FormState>();

  final schoolNameController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final schoolTypeController = TextEditingController();
  final principalNameController = TextEditingController();
  final phoneController = TextEditingController();
  final classController = TextEditingController();
  final sectionController = TextEditingController();

  final List<String> classes = [];
  final Map<String, List<String>> classSections = {};

  bool isExisting = false;

  @override
  void dispose() {
    schoolNameController.dispose();
    schoolCodeController.dispose();
    schoolTypeController.dispose();
    principalNameController.dispose();
    phoneController.dispose();
    classController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  Future<void> _saveSchool() async {
    if (_formKey.currentState!.validate()) {
      try {
        final codeText = schoolCodeController.text.trim();
        final code = int.tryParse(codeText);
        if (code == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠ Invalid school code.')),
          );
          return;
        }

        final existingSchool = await widget.isarService.getSchoolByCode(code);

        final school = School()
          ..schoolName = schoolNameController.text
          ..schoolCode = code
          ..schoolType = schoolTypeController.text
          ..principalName = principalNameController.text
          ..phone1 = phoneController.text
          ..classes = List.from(classes)
          ..classSections = classSections.entries.map((e) {
            return ClassSection()
              ..className = e.key
              ..sections = List.from(e.value);
          }).toList();

        if (existingSchool != null) {
          school.id = existingSchool.id;
        }

        await widget.isarService.addOrUpdateSchool(school);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              existingSchool != null
                  ? '✅ School details updated successfully.'
                  : '✅ School details saved successfully.',
            ),
          ),
        );

        // Clear safely
        schoolNameController.clear();
        schoolCodeController.clear();
        schoolTypeController.clear();
        principalNameController.clear();
        phoneController.clear();
        classController.clear();
        sectionController.clear();

        setState(() {
          isExisting = false;
          classes.clear();
          classSections.clear();
        });

        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Failed to save: $e')));
      }
    }
  }

  Future<void> _checkExistingSchool() async {
    final codeText = schoolCodeController.text.trim();
    final code = int.tryParse(codeText);

    if (code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠ Please enter a valid school code.')),
      );
      return;
    }

    final school = await widget.isarService.getSchoolByCode(code);

    if (school != null) {
      setState(() {
        isExisting = true;
        schoolNameController.text = school.schoolName;
        schoolTypeController.text = school.schoolType;
        principalNameController.text = school.principalName;
        phoneController.text = school.phone1;
        classes.clear();
        classes.addAll(school.classes);
        classSections.clear();
        for (final cs in school.classSections) {
          classSections[cs.className] = List.from(cs.sections);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✔ Existing school data loaded successfully.'),
        ),
      );
    } else {
      setState(() {
        isExisting = false;
        schoolNameController.clear();
        schoolTypeController.clear();
        principalNameController.clear();
        phoneController.clear();
        classes.clear();
        classSections.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ℹ No existing school found. You can add a new one.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration({
    VoidCallback? suffixAction,
    IconData? suffixIcon,
    String? helperText,
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      helperText: helperText,
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.sp)),
      contentPadding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.w),
      suffixIcon: suffixAction != null && suffixIcon != null
          ? Tooltip(
              message: 'Check if this school code already exists.',
              child: IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixAction,
              ),
            )
          : null,
    );
  }

  void _addClass() {
    final className = classController.text.trim();
    if (className.isNotEmpty && !classes.contains(className)) {
      setState(() {
        classes.add(className);
        classSections[className] = [];
        classController.clear();
      });
    }
  }

  void _addSection(String className) {
    final section = sectionController.text.trim();
    if (section.isNotEmpty &&
        !(classSections[className] ?? []).contains(section)) {
      setState(() {
        classSections[className]!.add(section);
        sectionController.clear();
      });
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 0.5.h, top: 1.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add or Update School Details'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.h),
          child: Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              'Manage school data, classes, and sections easily.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 2.h),
                  _buildLabel('Enter school code'),
                  TextFormField(
                    controller: schoolCodeController,
                    decoration: _inputDecoration(
                      suffixAction: _checkExistingSchool,
                      suffixIcon: Icons.search,
                      helperText: 'Unique numeric identifier for the school.',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? 'Please enter the school code.'
                        : int.tryParse(v) == null
                        ? 'Code must be a number.'
                        : null,
                  ),
                  _buildLabel('Enter School Name'),
                  TextFormField(
                    controller: schoolNameController,
                    decoration: _inputDecoration(
                      helperText: 'Official name of the school.',
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter the school name.' : null,
                  ),
                  _buildLabel('Enter School Type'),
                  TextFormField(
                    controller: schoolTypeController,
                    decoration: _inputDecoration(
                      helperText: 'e.g., Government, Private, NGO',
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter the school type.' : null,
                  ),
                  _buildLabel('Enter Principal Name'),
                  TextFormField(
                    controller: principalNameController,
                    decoration: _inputDecoration(
                      helperText: 'Full name of the principal.',
                    ),
                    validator: (v) => v!.isEmpty
                        ? 'Please enter the principal\'s name.'
                        : null,
                  ),
                  _buildLabel('Enter Contact Number'),
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration(
                      helperText: 'Primary phone number for the school.',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter the contact number.' : null,
                  ),
                  SizedBox(height: 2.h),
                  const Divider(),
                  _buildLabel('Enter Classes'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: classController,
                          decoration: _inputDecoration(hintText: 'Class name'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Tooltip(
                        message: 'Add this class to the list',
                        child: ElevatedButton(
                          onPressed: _addClass,
                          child: const Text('Add Class'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  const Divider(),
                  ...classes.map(
                    (className) => Card(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class: $className',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: (classSections[className] ?? []).map((
                                s,
                              ) {
                                return Chip(
                                  label: Text(s),
                                  onDeleted: () {
                                    setState(
                                      () => classSections[className]!.remove(s),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: sectionController,
                                    decoration: _inputDecoration(
                                      hintText: 'Section name',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Tooltip(
                                  message: 'Add this section to the class.',
                                  child: ElevatedButton(
                                    onPressed: () => _addSection(className),
                                    child: const Text('Add Section'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    height: 8.h,
                    child: Tooltip(
                      message: 'Save all school details to the database.',
                      child: ElevatedButton.icon(
                        onPressed: _saveSchool,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: Text(
                          isExisting
                              ? 'Update School Details'
                              : 'Save School Details',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
