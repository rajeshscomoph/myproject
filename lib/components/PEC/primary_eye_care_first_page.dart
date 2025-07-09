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
    'PEC-1': ['Trilokpuri'],
    'PEC-2': [
      'Nangli',
      'Mehrauli',
      'Jaunapur',
      'Fatehpur Beri',
      'Dharuhera',
      'Sarai Kale Khan',
    ],
    'PEC-3': [
      'Sanjay Colony',
      'Jatkhor',
      'Tauru',
      'Janak Puri',
      'Patel Garden',
      'Sohna',
    ],
    'PEC-4': [
      'Nangal Raya',
      'Chirag Delhi',
      'Basant Gaon',
      'Batla House',
      'Garhi',
      'Madipur',
    ],
    'PEC-5': ['Punjabi Bagh/SSMI', 'Majnu ka Tila', 'RIP/Camp'],
  };

  bool get showChwField => _selectedNo != "Old";

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
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
      color: Colors.teal.shade50,
      elevation: 3,
      shadowColor: Colors.teal.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.teal.shade800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.teal.shade700)
            : null,
        filled: true,
        fillColor: Colors.white,
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

  Widget buildChoiceChipsWrap({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return ChoiceChip(
              label: Text(item, style: const TextStyle(fontSize: 14)),
              selected: selectedValue == item,
              onSelected: (_) => setState(() => onChanged(item)),
              selectedColor: Colors.teal.shade700,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: selectedValue == item ? Colors.white : Colors.black,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildChoiceChipsRow({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(item, style: const TextStyle(fontSize: 14)),
                selected: selectedValue == item,
                onSelected: (_) => setState(() => onChanged(item)),
                selectedColor: Colors.teal.shade700,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selectedValue == item ? Colors.white : Colors.black,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Primary Eye Care Form',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildSectionCard(
                    title: 'Center Selection',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildChoiceChipsWrap(
                          label: 'PEC',
                          selectedValue: _selectedPec,
                          items: pecClusters.keys.toList(),
                          onChanged: (value) {
                            _selectedPec = value;
                            _selectedCluster = null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedPec != null)
                          buildChoiceChipsWrap(
                            label: 'Cluster',
                            selectedValue: _selectedCluster,
                            items: pecClusters[_selectedPec!]!,
                            onChanged: (value) => _selectedCluster = value,
                          ),
                        if (_selectedCluster == 'RIP/Camp') ...[
                          const SizedBox(height: 16),
                          buildTextField(
                            label: 'Place',
                            controller: _placeController,
                            icon: Icons.location_on,
                          ),
                        ],
                      ],
                    ),
                  ),
                  buildSectionCard(
                    title: 'Patient Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          label: 'Name',
                          controller: _nameController,
                          icon: Icons.person,
                        ),
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
                        buildChoiceChipsRow(
                          label: 'Gender',
                          selectedValue: _selectedSex,
                          items: ['Male', 'Female', 'Other'],
                          onChanged: (value) => _selectedSex = value,
                        ),
                        const SizedBox(height: 12),
                        buildChoiceChipsWrap(
                          label: 'Patient registration type',
                          selectedValue: _selectedNo,
                          items: ['New', 'Old'],
                          onChanged: (value) => _selectedNo = value,
                        ),
                        if (showChwField) ...[
                          const SizedBox(height: 12),
                          buildChoiceChipsWrap(
                            label: 'How do you know about PEC?',
                            selectedValue: _selectedChw,
                            items: ['Self', 'ASHA/Volunteer', 'Other'],
                            onChanged: (value) => _selectedChw = value,
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
                        backgroundColor: Colors.teal.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      label: const Text('Next', style: TextStyle(fontSize: 18)),
                      onPressed: _goToNextPage,
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
