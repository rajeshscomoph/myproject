import 'package:flutter/material.dart';
import 'package:myproject/components/dropdown_component.dart';
import 'package:myproject/components/form_page.dart';
import 'package:myproject/pages/main_pages/app_specific/form_page.dart'; // import FormPage

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

  // existing variables
  String? _selectedFamilyHis, _selectedDiabetes, _selectedFundusTaken;
  String? _selectedGlucomaSusRE, _selectedGlucomaSusLE;
  String? _vision, _hearing, _walking, _remember, _selfCare, _comCation;

  final TextEditingController _iopReController = TextEditingController();
  final TextEditingController _iopLeController = TextEditingController();
  final TextEditingController _fundNotTakenReasController =
      TextEditingController();

  // new variables
  String? _wearGlass, _referred;
  final TextEditingController _pva1Controller = TextEditingController();
  final TextEditingController _pva2Controller = TextEditingController();
  final TextEditingController _pvaNearController = TextEditingController();
  final TextEditingController _diagnosisCodeController =
      TextEditingController();
  final TextEditingController _otherMController = TextEditingController();
  final TextEditingController _clinicController = TextEditingController();

  final List<String> difficultyLevels = [
    '1\tNo difficulty',
    '2\tSome difficulty',
    '3\tA lot of difficulty',
    '4\tCannot do at all',
  ];

  bool get showExtraFields => widget.selectedPec == "PEC-1";
  bool get showIOPFields {
    final age = int.tryParse(widget.age) ?? 0;
    return _selectedFamilyHis == "Yes" || age >= 40;
  }

  bool get showFundusFields {
    if (!showIOPFields) return false;
    final iopRe = int.tryParse(_iopReController.text) ?? 0;
    final iopLe = int.tryParse(_iopLeController.text) ?? 0;
    return iopRe >= 25 || iopLe >= 25;
  }

  bool get showFundNotTakenReason =>
      _selectedFundusTaken != null && _selectedFundusTaken != "Yes";
  bool get showGlucomaSusFields =>
      widget.selectedPec == "PEC-1" && _selectedFundusTaken == "Yes";
  bool get showNewOnlyFields => widget.selectedNo == "New";

  @override
  void dispose() {
    _iopReController.dispose();
    _iopLeController.dispose();
    _fundNotTakenReasController.dispose();
    _pva1Controller.dispose();
    _pva2Controller.dispose();
    _pvaNearController.dispose();
    _diagnosisCodeController.dispose();
    _otherMController.dispose();
    _clinicController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final summary =
          '''
PEC: ${widget.selectedPec}
Cluster: ${widget.selectedCluster}
Place: ${widget.place}
OPD: ${widget.opd}
Name: ${widget.name}
Age: ${widget.age}
Sex: ${widget.selectedSex}
N_O: ${widget.selectedNo}
Phone: ${widget.phone}
How do you know about PEC?: ${widget.selectedChw}
Family History: $_selectedFamilyHis
Diabetes: $_selectedDiabetes
IOP_RE: ${_iopReController.text.trim()}
IOP_LE: ${_iopLeController.text.trim()}
Fundus Taken: $_selectedFundusTaken
Fund Not Taken Reason: ${_fundNotTakenReasController.text.trim()}
GlucomaSusRE: $_selectedGlucomaSusRE
GlucomaSusLE: $_selectedGlucomaSusLE
Vision: $_vision
Hearing: $_hearing
Walking: $_walking
Remember: $_remember
Self Care: $_selfCare
ComCation: $_comCation
Wear Glass: $_wearGlass
PVA1: ${_pva1Controller.text.trim()}
PVA2: ${_pva2Controller.text.trim()}
PVA Near: ${_pvaNearController.text.trim()}
Diagnosis Code: ${_diagnosisCodeController.text.trim()}
OtherM: ${_otherMController.text.trim()}
Referred: $_referred
Clinic: ${_clinicController.text.trim()}
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
                    state.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    maxLines: 3,
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
            errorMaxLines: 3,
          ),
          onChanged: (_) => setState(() {}),
          validator: (value) {
            final trimmed = value?.trim() ?? '';
            if (trimmed.isEmpty) return 'Please enter $label';
            if (min != null && max != null) {
              final number = int.tryParse(trimmed);
              if (number == null) return '$label must be a number';
              if (number < min || number > max) {
                return '$label must be between $min and $max';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Primary Eye Care - Page 2',
      child: Form(
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
                label: 'Diabetes',
                selectedValue: _selectedDiabetes,
                items: ['Yes', 'No'],
                onChanged: (v) => setState(() => _selectedDiabetes = v),
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
              if (showFundusFields) ...[
                buildDropdown(
                  label: 'Fundus Taken',
                  selectedValue: _selectedFundusTaken,
                  items: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _selectedFundusTaken = v),
                ),
                const SizedBox(height: 16),
                if (showFundNotTakenReason)
                  buildTextField(
                    label: 'Fund Not Taken Reason',
                    controller: _fundNotTakenReasController,
                  ),
                const SizedBox(height: 16),
              ],
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
            if (showNewOnlyFields) ...[
              buildDropdown(
                label: 'Vision',
                selectedValue: _vision,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _vision = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Hearing',
                selectedValue: _hearing,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _hearing = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Walking',
                selectedValue: _walking,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _walking = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Remember',
                selectedValue: _remember,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _remember = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Self Care',
                selectedValue: _selfCare,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _selfCare = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'ComCation',
                selectedValue: _comCation,
                items: difficultyLevels,
                onChanged: (v) => setState(() => _comCation = v),
              ),
              const SizedBox(height: 16),
            ],
            // new fields
            buildDropdown(
              label: 'Wear Glass',
              selectedValue: _wearGlass,
              items: ['Yes', 'No'],
              onChanged: (v) => setState(() => _wearGlass = v),
            ),
            const SizedBox(height: 16),
            buildTextField(label: 'PVA1', controller: _pva1Controller),
            const SizedBox(height: 16),
            buildTextField(label: 'PVA2', controller: _pva2Controller),
            const SizedBox(height: 16),
            buildTextField(label: 'PVA Near', controller: _pvaNearController),
            const SizedBox(height: 16),
            buildTextField(
              label: 'Diagnosis Code',
              controller: _diagnosisCodeController,
            ),
            const SizedBox(height: 16),
            buildTextField(label: 'OtherM', controller: _otherMController),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'Referred',
              selectedValue: _referred,
              items: ['Yes', 'No'],
              onChanged: (v) => setState(() => _referred = v),
            ),
            const SizedBox(height: 16),
            buildTextField(label: 'Clinic', controller: _clinicController),
            const SizedBox(height: 24),
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
