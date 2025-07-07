import 'package:flutter/material.dart';
import 'package:myproject/components/dropdown_component.dart';
import 'primary_eye_care_second_page.dart';

class PrimaryEyeCareFirstPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PrimaryEyeCareFirstPage({super.key, required this.formKey});

  @override
  State<PrimaryEyeCareFirstPage> createState() =>
      _PrimaryEyeCareFirstPageState();
}

class _PrimaryEyeCareFirstPageState extends State<PrimaryEyeCareFirstPage> {
  String? _selectedPec;
  String? _selectedCluster;
  String? _selectedSex;
  String? _selectedNo;
  String? _selectedChw;

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _opdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

  bool get showChwField => _selectedNo != "Old";

  @override
  void dispose() {
    _placeController.dispose();
    _opdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (widget.formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrimaryEyeCareSecondPage(
            selectedPec: _selectedPec!,
            selectedCluster: _selectedCluster!,
            place: _placeController.text.trim(),
            opd: _opdController.text.trim(),
            name: _nameController.text.trim(),
            age: _ageController.text.trim(),
            phone: _phoneController.text.trim(),
            selectedSex: _selectedSex!,
            selectedNo: _selectedNo!,
            selectedChw: _selectedChw,
          ),
        ),
      );
    }
  }

  Widget buildDropdown({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? customValidator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        FormField<String>(
          validator: (_) {
            if (customValidator != null) {
              return customValidator(selectedValue);
            }
            return selectedValue == null ? 'Please select $label' : null;
          },
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
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
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
    String? Function(String?)? customValidator,
    bool isRequired = true,
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
          validator: (value) {
            if (customValidator != null) {
              return customValidator(value);
            }
            final trimmed = value?.trim() ?? '';
            if (isRequired && trimmed.isEmpty) {
              return 'Please enter $label';
            }
            if (trimmed.isNotEmpty && min != null && max != null) {
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
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            items: _selectedPec != null ? pecClusters[_selectedPec!]! : [],
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
            min: 0,
            max: 99999999,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          buildTextField(label: 'Name', controller: _nameController),
          const SizedBox(height: 16),

          buildTextField(
            label: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
            min: 0,
            max: 100,
            isRequired: true,
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
            customValidator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.length != 10) {
                return 'Phone number must be exactly 10 digits';
              }
              if (!RegExp(r'^[789]\d{9}$').hasMatch(trimmed)) {
                return 'Phone number must start with 7, 8, or 9';
              }
              return null;
            },
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

          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: _goToNextPage,
              child: const Text('Next', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
