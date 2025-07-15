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
      final school = School()
        ..schoolName = schoolNameController.text
        ..schoolCode = int.parse(schoolCodeController.text)
        ..schoolType = schoolTypeController.text
        ..principalName = principalNameController.text
        ..phone1 = phoneController.text
        ..classes = List.from(classes)
        ..classSections = classSections.entries.map((e) {
          return ClassSection()
            ..className = e.key
            ..sections = List.from(e.value);
        }).toList();


      final code = int.parse(schoolCodeController.text);
      final existingSchool = await widget.isarService.getSchoolByCode(code);

      if (existingSchool != null) {
        school.id =
            existingSchool.id; // ✅ preserve id to update instead of insert
      }

      await widget.isarService.addOrUpdateSchool(school);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isExisting
                ? '✅ School updated successfully!'
                : '✅ School added successfully!',
          ),
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        isExisting = false;
        classes.clear();
        classSections.clear();
      });
    }
  }

  Future<void> _checkExistingSchool() async {
    final codeText = schoolCodeController.text.trim();
    if (codeText.isEmpty || int.tryParse(codeText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠ Please enter a valid School Code')),
      );
      return;
    }
    final code = int.parse(codeText);
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
        const SnackBar(content: Text('✔ Existing school data loaded')),
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
          content: Text('ℹ No existing school found. You can add new.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(
    String label, {
    VoidCallback? suffixAction,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
     border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.sp)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.sp),
        ),
      contentPadding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.w),
      suffixIcon: suffixAction != null && suffixIcon != null
          ? IconButton(icon: Icon(suffixIcon), onPressed: suffixAction)
          : null,
    );
  }

  @override
  Widget build(BuildContext context ) {
     
    return Scaffold(
      appBar: AppBar(title: const Text('Add School, Classes & Sections')),
      body: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: schoolCodeController,
                    decoration: _inputDecoration(
                      'Enter School Code',
                      suffixAction: _checkExistingSchool,
                      suffixIcon: Icons.search,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? 'Please enter School Code'
                        : int.tryParse(v) == null
                        ? 'Must be a number'
                        : null,
                  ),
                  SizedBox(height: 1.5.h),
                  TextFormField(
                    controller: schoolNameController,
                    decoration: _inputDecoration('Enter School Name'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter School Name' : null,
                  ),
                  SizedBox(height: 1.5.h),
                  TextFormField(
                    controller: schoolTypeController,
                    decoration: _inputDecoration('Enter School Type'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter School Type' : null,
                  ),
                  SizedBox(height: 1.5.h),
                  TextFormField(
                    controller: principalNameController,
                    decoration: _inputDecoration('Enter Principal Name'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter Principal Name' : null,
                  ),
                  SizedBox(height: 1.5.h),
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration('Enter School Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter Phone Number' : null,
                  ),
                  SizedBox(height: 1.5.h),
                  const Divider(),
                  SizedBox(height: 1.5.h),
                  const Text(
                    'Classes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: classController,
                          decoration: _inputDecoration('Enter Class'),
                        ),
                      ),
                      SizedBox(width:8.w),
                      ElevatedButton(
                        onPressed: () {
                          final className = classController.text.trim();
                          if (className.isNotEmpty &&
                              !classes.contains(className)) {
                            setState(() {
                              classes.add(className);
                              classSections[className] = [];
                              classController.clear();
                            });
                          }
                        },
                      child: const Text('Add'),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  const Divider(),
                  ...classes.map((className) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
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
                                    setState(() {
                                      classSections[className]!.remove(s);
                                    });
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
                                      'Enter Section',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                ElevatedButton(
                                  onPressed: () {
                                    final section = sectionController.text
                                        .trim();
                                    if (section.isNotEmpty &&
                                        !(classSections[className] ?? [])
                                            .contains(section)) {
                                      setState(() {
                                        classSections[className]!.add(section);
                                        sectionController.clear();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                   
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    height: 8.h,
                    child: ElevatedButton.icon(
                      onPressed: _saveSchool,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(isExisting ? 'Update' : 'Save'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
