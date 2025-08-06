import 'package:flutter/material.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptometristStudentScreen extends StatefulWidget {
  final Student student;
  final IsarService isarService;

  const OptometristStudentScreen({
    super.key,
    required this.student,
    required this.isarService,
  });

  @override
  State<OptometristStudentScreen> createState() =>
      _OptometristStudentScreenState();
}

class _OptometristStudentScreenState extends State<OptometristStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController uva1Ctrl = TextEditingController();
  final TextEditingController uva2Ctrl = TextEditingController();
  final TextEditingController pva1Ctrl = TextEditingController();
  final TextEditingController pva2Ctrl = TextEditingController();

  final TextEditingController pogCtrl = TextEditingController();
  final TextEditingController pogSph1Ctrl = TextEditingController();
  final TextEditingController pogCly1Ctrl = TextEditingController();
  final TextEditingController pogAxis1Ctrl = TextEditingController();
  final TextEditingController pogSph2Ctrl = TextEditingController();
  final TextEditingController pogCly2Ctrl = TextEditingController();
  final TextEditingController pogAxis2Ctrl = TextEditingController();

  final TextEditingController cycloCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill from student object if available
    uva1Ctrl.text = widget.student.cutoffUVA1!;
    uva2Ctrl.text = widget.student.cutoffUVA2!;
    pva1Ctrl.text = widget.student.pva1 ?? '';
    pva2Ctrl.text = widget.student.pva2 ?? '';
    pogCtrl.text = widget.student.pog ?? '';
    pogSph1Ctrl.text = widget.student.pogSph1 ?? '';
    pogCly1Ctrl.text = widget.student.pogCly1 ?? '';
    pogAxis1Ctrl.text = widget.student.pogAxis1 ?? '';
    pogSph2Ctrl.text = widget.student.pogSph2 ?? '';
    pogCly2Ctrl.text = widget.student.pogCly2 ?? '';
    pogAxis2Ctrl.text = widget.student.pogAxis2 ?? '';
    cycloCtrl.text = widget.student.cyclo ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    widget.student
      ..cutoffUVA1 = uva1Ctrl.text.trim()
      ..cutoffUVA2 = uva2Ctrl.text.trim()
      ..pva1 = pva1Ctrl.text.trim()
      ..pva2 = pva2Ctrl.text.trim()
      ..pog = pogCtrl.text.trim()
      ..pogSph1 = pogSph1Ctrl.text.trim()
      ..pogCly1 = pogCly1Ctrl.text.trim()
      ..pogAxis1 = pogAxis1Ctrl.text.trim()
      ..pogSph2 = pogSph2Ctrl.text.trim()
      ..pogCly2 = pogCly2Ctrl.text.trim()
      ..pogAxis2 = pogAxis2Ctrl.text.trim()
      ..cyclo = cycloCtrl.text.trim();

    await widget.isarService.addOrUpdateStudent(widget.student);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Optometry data saved')));
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Optometrist Screening")),
      body: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("UVA1", uva1Ctrl),
              _buildField("UVA2", uva2Ctrl),
              _buildField("PVA1", pva1Ctrl),
              _buildField("PVA2", pva2Ctrl),
              _buildField("POG", pogCtrl),
              Row(
                children: [
                  Expanded(child: _buildField("POG Sph1", pogSph1Ctrl)),
                  SizedBox(width: 2.w),
                  Expanded(child: _buildField("POG Cly1", pogCly1Ctrl)),
                  SizedBox(width: 2.w),
                  Expanded(child: _buildField("POG Axis1", pogAxis1Ctrl)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildField("POG Sph2", pogSph2Ctrl)),
                  SizedBox(width: 2.w),
                  Expanded(child: _buildField("POG Cly2", pogCly2Ctrl)),
                  SizedBox(width: 2.w),
                  Expanded(child: _buildField("POG Axis2", pogAxis2Ctrl)),
                ],
              ),
              _buildField("Cyclo", cycloCtrl),
              SizedBox(height: 2.h),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
