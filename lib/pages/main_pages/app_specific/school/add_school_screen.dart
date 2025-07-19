// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddSchoolScreen extends StatefulWidget {
  final IsarService isarService;

  final School? existingSchool; // <-- make this optional

  const AddSchoolScreen({
    super.key,
    required this.isarService,
    this.existingSchool,
  });

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
  final Map<String, TextEditingController> sectionControllers = {};
  final List<String> classes = [];
  final Map<String, List<String>> classSections = {};
  String? selectedSchoolType;
  String? lastSelectedSchoolType; 
  bool isExisting = false;
  bool isSaving = false;

  final List<String> _schoolTypes = ['Govt', 'Private', 'Other'];


  void _loadSchoolData(School school, bool enable) {
    isExisting = true;

    schoolNameController.text = school.schoolName;
    schoolTypeController.text = school.schoolType;
    principalNameController.text = school.principalName;
    phoneController.text = school.phone1;
    lastSelectedSchoolType = selectedSchoolType ?? lastSelectedSchoolType;

    // Normalize and validate school type
    if (['Govt', 'Private', 'Other'].contains(school.schoolType)) {
      selectedSchoolType = school.schoolType;
    } else if (school.schoolType == 'Government') {
      selectedSchoolType = 'Govt';
    } else {
      selectedSchoolType = null; // fallback
    }

    // Load class and section data
    classes.clear();
    classes.addAll(school.classes);

    classSections.clear();
    sectionControllers.clear();
    for (final cs in school.classSections) {
      classSections[cs.className] = List.from(cs.sections);
      if (enable) sectionControllers[cs.className] = TextEditingController();
    }
  }

  @override
  void initState() {
    super.initState();
    final school = widget.existingSchool;
    if (school != null) {
      schoolCodeController.text = school.schoolCode.toString();
      _loadSchoolData(school,true);
    }
  }

  @override
  void dispose() {
    schoolNameController.dispose();
    schoolCodeController.dispose();
    schoolTypeController.dispose();
    principalNameController.dispose();
    phoneController.dispose();
    classController.dispose();
    for (var controller in sectionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSchool() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await _showConfirmationDialog(
      title: isExisting ? 'Update School' : 'Save School',
      message: isExisting
          ? 'Are you sure you want to update this school?'
          : 'Are you sure you want to save this new school?',
    );
    if (!confirmed) return;

    setState(() => isSaving = true);
    try {
      final code = int.tryParse(schoolCodeController.text.trim());
      if (code == null) {
        _showSnackBar('⚠ Invalid school code.');
        setState(() => isSaving = false);
        return;
      }

      final existingSchool = await widget.isarService.getSchoolByCode(code);

      final school = School()
        ..schoolName = schoolNameController.text.trim()
        ..schoolCode = code
        ..schoolType = selectedSchoolType ?? ''
        ..principalName = principalNameController.text.trim()
        ..phone1 = phoneController.text.trim()
        ..classes = List.from(classes..sort())
        ..classSections = classSections.entries.map((e) {
          return ClassSection()
            ..className = e.key
            ..sections = List.from(e.value);
        }).toList();

      if (existingSchool != null) {
        school.id = existingSchool.id;
      }

      await widget.isarService.addOrUpdateSchool(school);

      if (selectedSchoolType == null) {
        _showSnackBar('⚠ Please select a school type.');
        setState(() => isSaving = false);
        return;
      }
      _showSnackBar(
        existingSchool != null
            ? '✅ School details updated successfully.'
            : '✅ School details saved successfully.',
      );

      _clearAll();
    } catch (e) {
      _showSnackBar('❌ Failed to save: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _checkExistingSchool() async {
    final code = int.tryParse(schoolCodeController.text.trim());
    if (code == null) {
      _showSnackBar('⚠ Please enter a valid school code.');
      return;
    }

    final school = await widget.isarService.getSchoolByCode(code);

    if (school != null) {
      setState(() {
        _loadSchoolData(school, false);
      });
      _showSnackBar('✔ Existing school data loaded successfully.');
    } else {
      final prevCode = schoolCodeController.text;
      setState(() {
        isExisting = false;
        _clearAll();
        schoolCodeController.text = prevCode;
      });
      _showSnackBar('ℹ No existing school found. You can add a new one.');
    }
  }

  Future<void> _removeClass(String className) async {
    final confirmed = await _showConfirmationDialog(
      title: 'Remove Class',
      message: 'Are you sure you want to remove class "$className"?',
    );
    if (confirmed) {
      setState(() {
        classes.remove(className);
        classSections.remove(className);
        sectionControllers[className]?.dispose();
        sectionControllers.remove(className);
      });
    }
  }

  Future<void> _removeSection(String className, String section) async {
    final confirmed = await _showConfirmationDialog(
      title: 'Remove Section',
      message: 'Remove section "$section" from class "$className"?',
    );
    if (confirmed) {
      setState(() => classSections[className]?.remove(section));
    }
  }

  void _addClass() {
    final className = classController.text.trim();
    if (className.isNotEmpty &&
        !classes.any((c) => c.toLowerCase() == className.toLowerCase())) {
      setState(() {
        classes.add(className);
        classSections[className] = [];
        sectionControllers[className] = TextEditingController();
        classController.clear();
      });
    }
  }

  void _addSection(String className) {
    if (!classSections.containsKey(className)) {
      _showSnackBar('⚠ Class "$className" does not exist.');
      return;
    }
    final controller = sectionControllers[className];
    if (controller == null) return;

    final section = controller.text.trim();
    if (section.isNotEmpty &&
        !(classSections[className] ?? []).any(
          (s) => s.toLowerCase() == section.toLowerCase(),
        )) {
      setState(() {
        classSections[className]?.add(section);
        controller.clear();
      });
    }
  }

  void _clearAll() {
    schoolNameController.clear();
    schoolCodeController.clear();
    schoolTypeController.clear();
    principalNameController.clear();
    phoneController.clear();
    classController.clear();

    for (var controller in sectionControllers.values) {
      controller.clear();
    }

    classes.clear();
    classSections.clear();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
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

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 0.5.h, top: 1.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
    ),
  );

  Widget _buildClassCard(String className) {
    final controller = sectionControllers[className] ?? TextEditingController();
    sectionControllers[className] = controller;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Class: $className',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  tooltip: 'Remove this class',
                  onPressed: () => _removeClass(className),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: (classSections[className] ?? []).map((s) {
                return Chip(
                  label: Text(s),
                  onDeleted: () => _removeSection(className, s),
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: _inputDecoration(hintText: 'Section name'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarComponent(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.sp),
          child: Column(
            children: [
              Text(
                'Add/Update School Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                'Manage school data, classes, and sections easily',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.sp),
                ),
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.sp, 8.sp, 14.sp, 8.sp),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 1.h),
                        _buildLabel('Enter School Code'),
                        TextFormField(
                          controller: schoolCodeController,
                          decoration: _inputDecoration(
                            suffixAction: _checkExistingSchool,
                            suffixIcon: Icons.search,
                            helperText:
                                'Unique numeric identifier for the school.',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.trim().isEmpty
                              ? 'Please enter the school code.'
                              : int.tryParse(v.trim()) == null
                              ? 'Code must be a number.'
                              : null,
                        ),
                        _buildLabel('Enter School Name'),
                        TextFormField(
                          controller: schoolNameController,
                          decoration: _inputDecoration(
                            helperText: 'Official name of the school.',
                          ),
                          validator: (v) => v!.trim().isEmpty
                              ? 'Please enter the school name.'
                              : null,
                        ),
                        _buildLabel('Select School Type'),
                       Wrap(
                          spacing: 8.sp,
                          children: _schoolTypes.map((type) {
                            final isSelected = selectedSchoolType == type;

                            final icon = type == 'Govt'
                                ? Icons.apartment
                                : type == 'Private'
                                ? Icons.school
                                : Icons.help_outline;

                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: 18,
                                    color: isSelected ? Colors.white : null,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(type),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  lastSelectedSchoolType = selectedSchoolType ?? lastSelectedSchoolType;
                                  selectedSchoolType = type;
                                });
                              },
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                            );
                          }).toList(),
                        ),
                        if (selectedSchoolType == null && lastSelectedSchoolType != null)
                          Padding(
                            padding: EdgeInsets.only(top: 1.h, left: 1.h),
                            child: Text(
                              'Please select a school type.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),


                        _buildLabel('Enter Principal Name'),
                        TextFormField(
                          controller: principalNameController,
                          decoration: _inputDecoration(
                            helperText: 'Full name of the principal.',
                          ),
                          validator: (v) => v!.trim().isEmpty
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
                          validator: (v) => v!.trim().isEmpty
                              ? 'Please enter the contact number.'
                              : null,
                        ),
                        SizedBox(height: 2.h),
                        const Divider(),
                        _buildLabel('Enter Classes'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: classController,
                                decoration: _inputDecoration(
                                  hintText: 'Class name',
                                ),
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
                        ...classes.map(_buildClassCard),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          height: 8.h,
                          child: Tooltip(
                            message: 'Save all school details to the database.',
                            child: ElevatedButton.icon(
                              onPressed: isSaving ? null : _saveSchool,
                              icon: isSaving
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save, color: Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }
}
