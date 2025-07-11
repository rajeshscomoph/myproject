// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/school.dart';

class AddSchoolScreen extends StatefulWidget {
  final AppDatabase db;

  const AddSchoolScreen({super.key, required this.db, required themeNotifier});

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

  bool isExisting = false; // editing existing school

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
      final school = School(
        schoolName: schoolNameController.text,
        schoolCode: int.parse(schoolCodeController.text),
        schoolType: schoolTypeController.text,
        principalName: principalNameController.text,
        phone1: phoneController.text,
        classes: List.from(classes),
        classSections: Map.from(classSections),
      );

      if (isExisting) {
        await widget.db.updateSchool(school);
      } else {
        await widget.db.insertSchool(school);
      }

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

  InputDecoration _inputDecoration(
    String label, {
    VoidCallback? suffixAction,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFE0F2F1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF26A69A), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF80CBC4), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      suffixIcon: suffixAction != null && suffixIcon != null
          ? IconButton(icon: Icon(suffixIcon), onPressed: suffixAction)
          : null,
    );
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
    final school = await widget.db.getSchoolByCode(code);

    if (school != null) {
      setState(() {
        isExisting = true;
        schoolNameController.text = school.schoolName;
        schoolTypeController.text = school.schoolType;
        principalNameController.text = school.principalName;
        phoneController.text = school.phone1;
        classes.clear();
        classes.addAll(school.classes ?? []);
        classSections.clear();
        classSections.addAll(school.classSections ?? {});
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


  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF26A69A);
    final cardColor = const Color(0xFFD0ECE7);

    return Scaffold(
      appBar: AppBar(title: const Text('Add School, Classes & Sections')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: schoolCodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter School Code',
                      filled: true,
                      fillColor: const Color(0xFFE0F2F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF26A69A),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF80CBC4),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      suffixIcon: _checkExistingSchool != null && Icons.search != null
                          ? IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _checkExistingSchool,
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? 'Please enter School Code'
                        : int.tryParse(v) == null
                        ? 'Must be a number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: schoolNameController,
                    decoration: _inputDecoration('Enter School Name'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter School Name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: schoolTypeController,
                    decoration: _inputDecoration('Enter School Type'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter School Type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: principalNameController,
                    decoration: _inputDecoration('Enter Principal Name'),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter Principal Name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration('Enter School Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter Phone Number' : null,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Classes & Sections',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: classController,
                          decoration: _inputDecoration('Enter Class Name'),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...classes.map((className) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
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
                                      'Enter Section Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saveSchool,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(isExisting ? 'Update' : 'Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
