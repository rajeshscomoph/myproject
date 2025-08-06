// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/debouncer_component.dart';
import 'package:myproject/components/showConfirmationDialog.dart';
import 'package:myproject/config.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';

import 'package:myproject/components/labeled_text_form_field_component.dart';


class ClassInfo {
  final TextEditingController sectionController;
  final List<String> sections;

  ClassInfo({TextEditingController? controller, List<String>? sections})
    : sectionController = controller ?? TextEditingController(),
      sections = sections ?? [];

  void dispose() {
    sectionController.dispose();
  }
}

class AddSchoolScreen extends StatefulWidget {
  final IsarService isarService;

  final int? schoolCode; // <-- make this optional

  const AddSchoolScreen({
    super.key,
    required this.isarService,
    this.schoolCode,
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

  SchoolType? selectedSchoolType;
  SchoolType? lastSelectedSchoolType;
  bool isExisting = false;
  bool isSaving = false;


  final DebouncerComponent<int> schoolCodeDebouncer = DebouncerComponent<int>();
final Map<String, ClassInfo> classInfos = {};


  void _loadSchoolData(School school, bool enable) {
    config.logger.i("🟡 _loadSchoolData started | enable=$enable");
    config.logger.i("📦 School: ${school.toJson()}");

    isExisting = true;

    schoolNameController.text = school.schoolName;
    schoolTypeController.text = school.schoolType;
    principalNameController.text = school.principalName;
    phoneController.text = school.phone1;

    config.logger.i("""
📋 Controllers:
  schoolName: '${school.schoolName}'
  schoolType: '${school.schoolType}'
  principalName: '${school.principalName}'
  phone: '${school.phone1}'
""");

    lastSelectedSchoolType = selectedSchoolType ?? lastSelectedSchoolType;

    // Set school type using enum helper
    selectedSchoolType = SchoolTypeExtension.fromString(school.schoolType);
    config.logger.i("✅ School type set: '$selectedSchoolType'");

    // Clear existing classInfos and dispose controllers if needed
    for (final info in classInfos.values) {
      info.dispose();
    }
    classInfos.clear();
    config.logger.d("🔄 Cleared previous classInfos");

    for (final cs in school.classSections) {
      final controller = enable
          ? TextEditingController()
          : TextEditingController(text: '');
      classInfos[cs.className] = ClassInfo(
        controller: controller,
        sections: List.from(cs.sections),
      );

      config.logger.i("➡ Class '${cs.className}' → Sections: ${cs.sections}");
      if (enable) {
        config.logger.d("🆕 Created controller for '${cs.className}'");
      } else {
        config.logger.d("⏭ Skipped controller input (readonly mode)");
      }
    }

    config.logger.i("✅ _loadSchoolData complete");
  }

  @override
  void initState() {
    super.initState();
    _loadSchoolIfEditing();

    schoolCodeController.addListener(() {
      schoolCodeDebouncer.run(
        text: schoolCodeController.text,
        parser: int.tryParse,
        onValidChange: _checkExistingSchool,
      );
    });
  }

  Future<void> _loadSchoolIfEditing() async {
    if (widget.schoolCode != null) {
      final school = await widget.isarService.getSchoolByCode(
        widget.schoolCode!,
      );
      if (school != null) {
        schoolCodeController.text = school.schoolCode.toString();
        _loadSchoolData(school, true);
        setState(() {
          isExisting = true;
        });
      }
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
    // Dispose all ClassInfo instances
    for (final info in classInfos.values) {
      info.dispose(); // ✅ encapsulated disposal
    }

    classInfos.clear();
    super.dispose();
  }

  Future<void> _saveSchool() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showConfirmationDialogComponent(
      context: context,
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

      final sortedClassNames = classInfos.keys.toList()..sort();

      final school = School()
        ..schoolName = schoolNameController.text.trim()
        ..schoolCode = code
        ..schoolType = selectedSchoolType?.label ?? ''
        ..principalName = principalNameController.text.trim()
        ..phone1 = phoneController.text.trim()
        ..classes = sortedClassNames
        ..classSections = sortedClassNames.map((className) {
          return ClassSection()
            ..className = className
            ..sections = List.from(classInfos[className]?.sections ?? []);
        }).toList();

      if (existingSchool != null) {
        school.id = existingSchool.id;
      }

      await widget.isarService.addOrUpdateSchool(school);
      Navigator.pop(context, school);

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

  Future<void> _checkExistingSchool([int? code]) async {
    final inputCode = code ?? int.tryParse(schoolCodeController.text.trim());
    if (inputCode == null) {
      _showSnackBar('⚠ Please enter a valid school code.');
      return;
    }

    final school = await widget.isarService.getSchoolByCode(inputCode);
    if (school != null) {
      _loadSchoolData(school, false);
      setState(() => isExisting = true);
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
    final confirmed = await showConfirmationDialogComponent(
      context: context,
      title: 'Remove Class',
      message: 'Are you sure you want to remove class "$className"?',
    );
    if (confirmed) {
      setState(() {
        classInfos[className]?.dispose(); // Dispose controller
        classInfos.remove(className); // Remove from map
      });
    }
  }


  Future<void> _removeSection(String className, String section) async {
  final confirmed = await showConfirmationDialogComponent(
    context: context,
    title: 'Remove Section',
    message: 'Remove section "$section" from class "$className"?',
  );
  if (confirmed) {
    setState(() {
      classInfos[className]?.sections.remove(section);
    });
  }
}


void _addClass() {
    final className = classController.text.trim();

    if (className.isEmpty) return;

    final exists = classInfos.keys.any(
      (c) => c.toLowerCase() == className.toLowerCase(),
    );

    if (!exists) {
      setState(() {
        classInfos[className] = ClassInfo();
        classController.clear();
      });
    }
  }


  void _addSection(String className) {
    final info = classInfos[className];

    if (info == null) {
      _showSnackBar('⚠ Class "$className" does not exist.');
      return;
    }

    final section = info.sectionController.text.trim().toUpperCase();

    final alreadyExists = info.sections.any(
      (s) => s.toLowerCase() == section.toLowerCase(),
    );

    if (section.isNotEmpty && !alreadyExists) {
      setState(() {
        info.sections.add(section);
        info.sectionController.clear();
      });
    }
  }


  void _clearAll() {
    // Clear form fields
    schoolNameController.clear();
    schoolCodeController.clear();
    schoolTypeController.clear();
    principalNameController.clear();
    phoneController.clear();
    classController.clear();

    // Clear each section controller inside classInfos
    for (final info in classInfos.values) {
      info.sectionController.clear();
      info.sections.clear();
    }

    // Or fully remove all classInfos and dispose their controllers
    for (final info in classInfos.values) {
      info.dispose(); // Clean disposal
    }
    classInfos.clear();

    selectedSchoolType = null;
    lastSelectedSchoolType = null;
  }


  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
    final info = classInfos[className];
    if (info == null) return const SizedBox();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shadowColor: Colors.black54,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header with Class name & delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CLASS: $className',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  tooltip: 'Remove this class',
                  onPressed: () => _removeClass(className),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),

            /// Section label
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                'SECTIONS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            /// Chips for existing sections
            Wrap(
              spacing: 8,
              children: info.sections.map((s) {
                return Chip(
                  label: Text(s),
                  onDeleted: () => _removeSection(className, s),
                );
              }).toList(),
            ),

            /// Input for new section
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: info.sectionController,
                    decoration: _inputDecoration(),
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
                        LabeledTextFormFieldComponent(
                          label: 'Enter School Code',
                          controller: schoolCodeController,
                          helperText:
                              'Unique numeric identifier for the school.',
                          keyboardType: TextInputType.number,
                          suffixIcon: Icons.search,
                          suffixAction: _checkExistingSchool,
                          validator: (v) {
                            final trimmed = v?.trim();
                            if (trimmed == null || trimmed.isEmpty) {
                              return 'Please enter the school code.';
                            } else if (int.tryParse(trimmed) == null) {
                              return 'Code must be a number.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _checkExistingSchool(),
                        ),

                        LabeledTextFormFieldComponent(
                          label: 'Enter School Name',
                          controller: schoolNameController,
                          helperText: 'Official name of the school.',
                          validator: (v) => v!.trim().isEmpty
                              ? 'Please enter the school name.'
                              : null,
                        ),

                        _buildLabel('Select School Type'),
                        Wrap(
                          spacing: 8.sp,
                          children: SchoolType.values.where((type) => type != SchoolType.all).map((type) {
                            final isSelected = selectedSchoolType == type;
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    type.icon,
                                    size: 18,
                                    color: isSelected ? Colors.white : null,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(type.label),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  lastSelectedSchoolType =
                                      selectedSchoolType ??
                                      lastSelectedSchoolType;
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
                        if (selectedSchoolType == null &&
                            lastSelectedSchoolType != null)
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

                        LabeledTextFormFieldComponent(
                          label: 'Enter Principal Name',
                          controller: principalNameController,
                          helperText: 'Full name of the principal.',
                          validator: (v) => v!.trim().isEmpty
                              ? 'Please enter the principal\'s name.'
                              : null,
                        ),

                        LabeledTextFormFieldComponent(
                          label: 'Enter Contact Number',
                          controller: phoneController,
                          helperText: 'Primary phone number for the school.',
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            final trimmed = v!.trim();
                            if (trimmed.isEmpty) {
                              return 'Please enter the contact number.';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
                              return 'Enter a valid 10-digit number.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 2.h),
                        const Divider(),
                        _buildLabel('Enter Classes'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: classController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: _inputDecoration(),
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
                        ...classInfos.keys.map(_buildClassCard),
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
