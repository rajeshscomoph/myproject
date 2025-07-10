import 'package:flutter/material.dart';
import 'package:myproject/components/dropdown_component.dart';

// I am adding just from commit - ravinder singh


class PrimaryEyeCareComponent extends StatefulWidget {
  const PrimaryEyeCareComponent({super.key});

  @override
  State<PrimaryEyeCareComponent> createState() =>
      _PrimaryEyeCareComponentState();
}

class _PrimaryEyeCareComponentState extends State<PrimaryEyeCareComponent> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPec;
  String? _selectedCluster;
  String? _selectedSex;
  String? _selectedNo; // New / Old
  String? _selectedChw; // Self / ASHA/Volunteer / Other
  String? _selectedFamilyHis; // Yes / No
  String? _selectedDiabeties; // Yes / No
  String? _selectedFundusTaken; // Yes / No
  String? _selectedGlucomaSusRE; // Yes / No
  String? _selectedGlucomaSusLE; // Yes / No

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _opdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _iopReController = TextEditingController();
  final TextEditingController _iopLeController = TextEditingController();
  final TextEditingController _fundNotTakenReasController =
      TextEditingController();

  final Map<String, List<String>> pecClusters = {
    'PEC-1': ['17-Trilokpuri'],
    'PEC-2': [
      '13-Nangli',
      '25-Mehrauli',
      '31-Jaunapur',
      '32-Fatehpur Beri',
      '44-Dharuhera',
      '49-Sarai Kale Khan',
    ],
    'PEC-3': [
      '4-Sanjay Colony',
      '16-Jatkhor',
      '34-Tauru',
      '43-Janak puri',
      '46-Patel Garden',
      '50-Sohna',
    ],
    'PEC-4': [
      '36-Nangal Raya',
      '45-Chirag Delhi',
      '39-Basant Gaon',
      '52-Batla House',
      '53-Garhi',
      '54-Madipur',
    ],
    'PEC-5': ['47-Punjabi Bagh/SSMI', '55-Majnu ka Tila', '99-RIP/Camp'],
  };

  @override
  void dispose() {
    _placeController.dispose();
    _opdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _iopReController.dispose();
    _iopLeController.dispose();
    _fundNotTakenReasController.dispose();
    super.dispose();
  }

  bool get showExtraFields => _selectedPec == "PEC-1";
  bool get showChwField => _selectedNo != "Old";

  bool get showIOPFields {
    final age = int.tryParse(_ageController.text) ?? 0;
    return _selectedFamilyHis == "Yes" || age >= 40;
  }

  bool get showFundusTaken {
    final iopRe = int.tryParse(_iopReController.text) ?? 0;
    final iopLe = int.tryParse(_iopLeController.text) ?? 0;
    return iopRe >= 25 || iopLe >= 25;
  }

  bool get showFundNotTakenReason =>
      _selectedFundusTaken != null && _selectedFundusTaken != "Yes";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String summary =
          '''
PEC: $_selectedPec
Cluster: $_selectedCluster
Place: ${_placeController.text.trim()}
OPD: ${_opdController.text.trim()}
Name: ${_nameController.text.trim()}
Age: ${_ageController.text.trim()}
Sex: $_selectedSex
N_O: $_selectedNo
Phone: ${_phoneController.text.trim()}
How do you know about PEC?: $_selectedChw
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
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            if (min != null && max != null) {
              final number = int.tryParse(value.trim());
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
          validator: (value) =>
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: Text(
              'Please fill the details below:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 24),

          buildDropdown(
            label: 'PEC',
            selectedValue: _selectedPec,
            items: pecClusters.keys.toList(),
            onChanged: (value) {
              setState(() {
                _selectedPec = value;
                _selectedCluster = null;
              });
            },
          ),
          const SizedBox(height: 16),

          buildDropdown(
            label: 'Cluster',
            selectedValue: _selectedCluster,
            items: _selectedPec != null ? pecClusters[_selectedPec]! : [],
            onChanged: (value) => setState(() => _selectedCluster = value),
          ),
          const SizedBox(height: 16),

          if (_selectedCluster == '99-RIP/Camp') ...[
            buildTextField(label: 'Place', controller: _placeController),
            const SizedBox(height: 16),
          ],

          buildTextField(
            label: 'OPD Number',
            controller: _opdController,
            keyboardType: TextInputType.number,
            min: 099999,
            max: 99999999,
          ),
          const SizedBox(height: 16),

          buildTextField(label: 'Name', controller: _nameController),
          const SizedBox(height: 16),

          buildTextField(
            label: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
            min: 0,
            max: 99,
          ),
          const SizedBox(height: 16),

          buildDropdown(
            label: 'Sex',
            selectedValue: _selectedSex,
            items: ['Male', 'Female', 'Other'],
            onChanged: (value) => setState(() => _selectedSex = value),
          ),
          const SizedBox(height: 16),

          buildDropdown(
            label: 'N_O',
            selectedValue: _selectedNo,
            items: ['New', 'Old'],
            onChanged: (value) => setState(() => _selectedNo = value),
          ),
          const SizedBox(height: 16),

          buildTextField(
            label: 'Phone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            min: 999999999,
            max: 9999999999,
          ),
          const SizedBox(height: 16),

          if (showChwField) ...[
            buildDropdown(
              label: 'How do you know about PEC?',
              selectedValue: _selectedChw,
              items: ['Self', 'ASHA/Volunteer', 'Other'],
              onChanged: (value) => setState(() => _selectedChw = value),
            ),
            const SizedBox(height: 16),
          ],

          if (showExtraFields) ...[
            buildDropdown(
              label: 'Family History',
              selectedValue: _selectedFamilyHis,
              items: ['Yes', 'No'],
              onChanged: (value) => setState(() => _selectedFamilyHis = value),
            ),
            const SizedBox(height: 16),

            buildDropdown(
              label: 'Diabeties',
              selectedValue: _selectedDiabeties,
              items: ['Yes', 'No'],
              onChanged: (value) => setState(() => _selectedDiabeties = value),
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
                onChanged: (value) =>
                    setState(() => _selectedFundusTaken = value),
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

            buildDropdown(
              label: 'GlucomaSusRE',
              selectedValue: _selectedGlucomaSusRE,
              items: ['Yes', 'No'],
              onChanged: (value) =>
                  setState(() => _selectedGlucomaSusRE = value),
            ),
            const SizedBox(height: 16),

            buildDropdown(
              label: 'GlucomaSusLE',
              selectedValue: _selectedGlucomaSusLE,
              items: ['Yes', 'No'],
              onChanged: (value) =>
                  setState(() => _selectedGlucomaSusLE = value),
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitForm,
              child: const Text('Submit', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
