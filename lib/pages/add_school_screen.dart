import 'package:flutter/material.dart';
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
  final schoolSNController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final schoolTypeController = TextEditingController();
  final principalNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    schoolNameController.dispose();
    schoolSNController.dispose();
    schoolCodeController.dispose();
    schoolTypeController.dispose();
    principalNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveSchool() async {
    if (_formKey.currentState!.validate()) {
      final school = School(
        schoolName: schoolNameController.text,
        schoolSN: schoolSNController.text,
        schoolCode: int.parse(schoolCodeController.text),
        schoolType: schoolTypeController.text,
        principalName: principalNameController.text,
        phone1: phoneController.text,
      );

      await widget.db.insertSchool(school);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ School saved successfully!')),
      );

      _formKey.currentState!.reset();
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFE0F2F1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF26A69A), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF80CBC4), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF26A69A);
    final cardColor = const Color(0xFFD0ECE7).withOpacity(0.7);

    return Scaffold(
      appBar: AppBar(title: const Text('Add School')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: schoolNameController,
                    decoration: _inputDecoration('School Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: schoolSNController,
                    decoration: _inputDecoration('School Sort Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: schoolCodeController,
                    decoration: _inputDecoration('School Code'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? 'Required'
                        : int.tryParse(v) == null
                        ? 'Must be number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: schoolTypeController,
                    decoration: _inputDecoration('School Type'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: principalNameController,
                    decoration: _inputDecoration('Principal Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration('School Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saveSchool,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Save'),
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
