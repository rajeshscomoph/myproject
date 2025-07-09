import 'package:flutter/material.dart';
import 'primary_eye_care_second_page.dart';

class PrimaryEyeCareFirstPage extends StatefulWidget {
  const PrimaryEyeCareFirstPage({super.key});

  @override
  State<PrimaryEyeCareFirstPage> createState() =>
      _PrimaryEyeCareFirstPageState();
}

class _PrimaryEyeCareFirstPageState extends State<PrimaryEyeCareFirstPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

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

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _placeController.dispose();
    _opdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_formKey.currentState!.validate()) {
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

  Widget buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
    int? min,
    int? max,
    String? Function(String?)? customValidator,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (customValidator != null) return customValidator(value);
        final trimmed = value?.trim() ?? '';
        if (isRequired && trimmed.isEmpty) return 'Please enter $label';
        if (trimmed.isNotEmpty && min != null && max != null) {
          final number = int.tryParse(trimmed);
          if (number == null) return '$label must be a number';
          if (number < min || number > max) {
            return '$label must be between $min and $max';
          }
        }
        return null;
      },
    );
  }

  Widget buildRadioGroup({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: -4,
          children: items.map((item) {
            return ChoiceChip(
              label: Text(item),
              selected: selectedValue == item,
              onSelected: (_) => onChanged(item),
              selectedColor: Colors.blueAccent.withOpacity(0.7),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: selectedValue == item ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Primary Eye Care Form',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            buildSectionCard(
                            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRadioGroup(
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
                  const SizedBox(height: 12),
                  if (_selectedPec != null)
                    buildRadioGroup(
                      label: 'Cluster',
                      selectedValue: _selectedCluster,
                      items: pecClusters[_selectedPec!]!,
                      onChanged: (value) =>
                          setState(() => _selectedCluster = value),
                    ),
                  if (_selectedCluster == '99-RIP/Camp') ...[
                    const SizedBox(height: 12),
                    buildTextField(
                        label: 'Place',
                        controller: _placeController,
                        icon: Icons.location_on),
                  ],
                ],
              ), title: '',
            ),

            buildSectionCard(
              title: 'Patient Details',
              child: Column(
                children: [
                  buildTextField(
                    label: 'OPD Number',
                    controller: _opdController,
                    keyboardType: TextInputType.number,
                    min: 0,
                    max: 99999999,
                    icon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                      label: 'Name', controller: _nameController, icon: Icons.person),
                  const SizedBox(height: 12),
                  buildTextField(
                    label: 'Age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    min: 0,
                    max: 100,
                    icon: Icons.cake,
                  ),
                  const SizedBox(height: 12),
                  buildRadioGroup(
                    label: 'Sex',
                    selectedValue: _selectedSex,
                    items: ['Male', 'Female', 'Other'],
                    onChanged: (value) => setState(() => _selectedSex = value),
                  ),
                  const SizedBox(height: 12),
                  buildRadioGroup(
                    label: 'N_O',
                    selectedValue: _selectedNo,
                    items: ['New', 'Old'],
                    onChanged: (value) => setState(() => _selectedNo = value),
                  ),
                  if (showChwField) ...[
                    const SizedBox(height: 12),
                    buildRadioGroup(
                      label: 'How do you know about PEC?',
                      selectedValue: _selectedChw,
                      items: ['Self', 'ASHA/Volunteer', 'Other'],
                      onChanged: (value) =>
                          setState(() => _selectedChw = value),
                    ),
                  ],
                  const SizedBox(height: 12),
                  buildTextField(
                    label: 'Phone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    icon: Icons.phone,
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
                ],
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Next', style: TextStyle(fontSize: 18)),
                onPressed: _goToNextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
