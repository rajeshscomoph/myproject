import 'package:flutter/material.dart';
import 'package:myproject/components/dropdown_component.dart';

class PrimaryEyeCareSecondPage extends StatefulWidget {
  final String selectedPec,
      selectedCluster,
      place,
      opd,
      name,
      age,
      phone,
      selectedSex,
      selectedNo;
  final String? selectedChw;

  const PrimaryEyeCareSecondPage({
    super.key,
    required this.selectedPec,
    required this.selectedCluster,
    required this.place,
    required this.opd,
    required this.name,
    required this.age,
    required this.phone,
    required this.selectedSex,
    required this.selectedNo,
    this.selectedChw,
  });

  @override
  State<PrimaryEyeCareSecondPage> createState() =>
      _PrimaryEyeCareSecondPageState();
}

class _PrimaryEyeCareSecondPageState extends State<PrimaryEyeCareSecondPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedFamilyHis,
      _selectedDiabeties,
      _selectedFundusTaken,
      _selectedGlucomaSusRE,
      _selectedGlucomaSusLE;
  final TextEditingController _iopReController = TextEditingController();
  final TextEditingController _iopLeController = TextEditingController();
  final TextEditingController _fundNotTakenReasController =
      TextEditingController();

  bool get showExtraFields => widget.selectedPec == "PEC-1";

  bool get showIOPFields {
    final age = int.tryParse(widget.age) ?? 0;
    return _selectedFamilyHis == "Yes" || age >= 40;
  }

  bool get showFundusTaken {
    final iopRe = int.tryParse(_iopReController.text) ?? 0;
    final iopLe = int.tryParse(_iopLeController.text) ?? 0;
    return iopRe >= 25 || iopLe >= 25;
  }

  bool get showFundNotTakenReason =>
      _selectedFundusTaken != null && _selectedFundusTaken != "Yes";

  // 👉 NEW CONDITION
  bool get showGlucomaSusFields =>
      widget.selectedPec == "PEC-1" && _selectedFundusTaken == "Yes";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String summary =
          '''
PEC: ${widget.selectedPec}
Cluster: ${widget.selectedCluster}
OPD: ${widget.opd}
Name: ${widget.name}
Age: ${widget.age}
Sex: ${widget.selectedSex}
N_O: ${widget.selectedNo}
Phone: ${widget.phone}
How do you know about PEC?: ${widget.selectedChw}
Family History: $_selectedFamilyHis
Diabeties: $_selectedDiabeties
IOP_RE: ${_iopReController.text.trim()}
IOP_LE: ${_iopLeController.text.trim()}
Fundus Taken: $_selectedFundusTaken
Fund Not Taken Reason: ${_fundNotTakenReasController.text.trim()}
GlucomaSusRE: $_selectedGlucomaSusRE
GlucomaSusLE: $_selectedGlucomaSusLE
''';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: SingleChildScrollView(child: Text(summary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildDropdown({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        FormField<String>(
          validator: (_) =>
              selectedValue == null ? 'Please select $label' : null,
          builder: (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdownAttached(
                items: items,
                selectedValue: selectedValue,
                onChanged: (value) {
                  onChanged(value);
                  state.didChange(value);
                },
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? min,
    int? max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
          ),
          onChanged: (_) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty)
              return 'Please enter $label';
            if (min != null && max != null) {
              final number = int.tryParse(value.trim());
              if (number == null) return '$label must be a number';
              if (number < min || number > max)
                return '$label must be between $min and $max';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _iopReController.dispose();
    _iopLeController.dispose();
    _fundNotTakenReasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primary Eye Care - Page 2')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (showExtraFields) ...[
              buildDropdown(
                label: 'Family History',
                selectedValue: _selectedFamilyHis,
                items: ['Yes', 'No'],
                onChanged: (v) => setState(() => _selectedFamilyHis = v),
              ),
              const SizedBox(height: 16),

              buildDropdown(
                label: 'Diabeties',
                selectedValue: _selectedDiabeties,
                items: ['Yes', 'No'],
                onChanged: (v) => setState(() => _selectedDiabeties = v),
              ),
              const SizedBox(height: 16),

              if (showIOPFields) ...[
                buildTextField(
                  label: 'IOP_RE',
                  controller: _iopReController,
                  keyboardType: TextInputType.number,
                  min: 0,
                  max: 100,
                ),
                const SizedBox(height: 16),

                buildTextField(
                  label: 'IOP_LE',
                  controller: _iopLeController,
                  keyboardType: TextInputType.number,
                  min: 0,
                  max: 100,
                ),
                const SizedBox(height: 16),
              ],

              if (showFundusTaken) ...[
                buildDropdown(
                  label: 'Fundus Taken',
                  selectedValue: _selectedFundusTaken,
                  items: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _selectedFundusTaken = v),
                ),
                const SizedBox(height: 16),
              ],

              if (showFundusTaken && showFundNotTakenReason) ...[
                buildTextField(
                  label: 'Fund Not Taken Reason',
                  controller: _fundNotTakenReasController,
                ),
                const SizedBox(height: 16),
              ],

              // 👉 SHOW only if PEC=1 & FundusTaken=Yes
              if (showGlucomaSusFields) ...[
                buildDropdown(
                  label: 'GlucomaSusRE',
                  selectedValue: _selectedGlucomaSusRE,
                  items: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _selectedGlucomaSusRE = v),
                ),
                const SizedBox(height: 16),

                buildDropdown(
                  label: 'GlucomaSusLE',
                  selectedValue: _selectedGlucomaSusLE,
                  items: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _selectedGlucomaSusLE = v),
                ),
                const SizedBox(height: 16),
              ],
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
