import 'package:flutter/material.dart';
import 'package:myproject/components/dropdown_component.dart';
import 'package:myproject/pages/main_pages/app_specific/form_page.dart';

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

  String? _selectedFamilyHis, _selectedDiabetes, _selectedFundusTaken;
  String? _selectedGlucomaSusRE, _selectedGlucomaSusLE;
  String? _vision, _hearing, _walking, _remember, _selfCare, _comCation;

  String? _wearGlass,
      _pva1,
      _pva2,
      _pvaNear,
      _diagnosisCode,
      _otherM,
      _referred,
      _clinic;

  final TextEditingController _iopReController = TextEditingController();
  final TextEditingController _iopLeController = TextEditingController();
  final TextEditingController _fundNotTakenReasController =
      TextEditingController();

  final List<String> yesNoList = ['Yes', 'No'];

  final List<String> pvaLabels = [
    '6/6',
    '6/9',
    '6/12',
    '6/18',
    '6/24',
    '6/36',
    '6/60',
    '5/60',
    '4/60',
    '3/60',
    '2/60',
    '1/60',
    'FCCF',
    'HMCF',
    'PL+',
    'PL-/ Phthisical Eye',
    'NC',
  ];

  final List<String> pvaNearLabels = ['Can Read N6', 'Can\'t Read N6'];

  final List<String> diagnosisLabels = [
    '1-Normal',
    '2-Refractive Error',
    '3-Presbyopia',
    '4-Conjunctivitis',
    '5-Cataract',
    '6-Diseases of adnexa',
    '7-Eye Injury/Trauma',
    '8-Squint',
    '9-Vit-A deficiency',
    '10-Corneal Opacity',
    '11-Glaucoma Suspect',
    '12-DR Suspect',
    '13-Other',
    '14-Cataract Sx. Follow up',
    '15-Retinal Pathologies',
    '16-Post Cataract Surgical Complications',
  ];

  final List<String> referredLabels = [
    '1-Referred to RPC',
    '2-Referred to DR Clinic',
    '3-Refraction',
    '4-Refraction & Referred to RPC',
    '5-No further Intervention',
    '6-Same Glass Continue',
    '7-Followup Next Week',
    '8-Not Referred due to Complication',
  ];

  final List<String> clinicLabels = [
    'Cataract',
    'Retina Clinic',
    'Oculoplasty Clinic',
    'Glaucoma Clinic',
    'Squint Clinic',
    'Lasik Clinic',
    'Eye Bank Clinic',
    'ROP Clinic',
    'Myopia Clinic',
    'Lens Clinic',
    'Cornea Clinic',
    'Uvea Clinic',
    'Amblyopia Clinic',
    'DR Clinic',
  ];

  final List<String> difficultyLevels = [
    'No difficulty',
    'Some difficulty',
    'A lot of difficulty',
    'Cannot do at all',
  ];

  bool get showExtraFields => widget.selectedPec == "PEC-1";
  bool get showIOPFields =>
      _selectedFamilyHis == "Yes" || (int.tryParse(widget.age) ?? 0) >= 40;
  bool get showFundusFields {
    if (!showIOPFields) return false;
    final iopRe = int.tryParse(_iopReController.text) ?? 0;
    final iopLe = int.tryParse(_iopLeController.text) ?? 0;
    return iopRe >= 25 || iopLe >= 25;
  }

  bool get showFundNotTakenReason => _selectedFundusTaken == "No";
  bool get showGlucomaSusFields =>
      widget.selectedPec == "PEC-1" && _selectedFundusTaken == "Yes";
  bool get showNewOnlyFields => widget.selectedNo == "New";
  bool get showPvaNear => (int.tryParse(widget.age) ?? 0) > 34;
  bool get showOtherM => _diagnosisCode?.startsWith('12-') ?? false;
  bool get showClinic =>
      _referred == '1-Referred to RPC' ||
      _referred == '4-Refraction & Referred to RPC';

  @override
  void dispose() {
    _iopReController.dispose();
    _iopLeController.dispose();
    _fundNotTakenReasController.dispose();
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
PVA1: $_pva1
PVA2: $_pva2
PVA Near: $_pvaNear
Diagnosis Code: $_diagnosisCode
OtherM: $_otherM
Referred: $_referred
Clinic: $_clinic
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
                onChanged: (v) {
                  onChanged(v);
                  state.didChange(v);
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) ? 'Please enter $label' : null,
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
                items: yesNoList,
                onChanged: (v) => setState(() => _selectedFamilyHis = v),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Diabetes',
                selectedValue: _selectedDiabetes,
                items: yesNoList,
                onChanged: (v) => setState(() => _selectedDiabetes = v),
              ),
              const SizedBox(height: 16),
              if (showIOPFields) ...[
                buildTextField(label: 'IOP_RE', controller: _iopReController),
                const SizedBox(height: 16),
                buildTextField(label: 'IOP_LE', controller: _iopLeController),
                const SizedBox(height: 16),
              ],
              if (showFundusFields) ...[
                buildDropdown(
                  label: 'Fundus Taken',
                  selectedValue: _selectedFundusTaken,
                  items: yesNoList,
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
                  items: yesNoList,
                  onChanged: (v) => setState(() => _selectedGlucomaSusRE = v),
                ),
                const SizedBox(height: 16),
                buildDropdown(
                  label: 'GlucomaSusLE',
                  selectedValue: _selectedGlucomaSusLE,
                  items: yesNoList,
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
            buildDropdown(
              label: 'Wear Glass',
              selectedValue: _wearGlass,
              items: yesNoList,
              onChanged: (v) => setState(() => _wearGlass = v),
            ),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'PVA1',
              selectedValue: _pva1,
              items: pvaLabels,
              onChanged: (v) => setState(() => _pva1 = v),
            ),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'PVA2',
              selectedValue: _pva2,
              items: pvaLabels,
              onChanged: (v) => setState(() => _pva2 = v),
            ),
            const SizedBox(height: 16),
            if (showPvaNear)
              buildDropdown(
                label: 'PVA Near',
                selectedValue: _pvaNear,
                items: pvaNearLabels,
                onChanged: (v) => setState(() => _pvaNear = v),
              ),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'Diagnosis Code',
              selectedValue: _diagnosisCode,
              items: diagnosisLabels,
              onChanged: (v) => setState(() => _diagnosisCode = v),
            ),
            const SizedBox(height: 16),
            if (showOtherM)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'OtherM',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => _otherM = v,
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Please enter OtherM' : null,
              ),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'Referred',
              selectedValue: _referred,
              items: referredLabels,
              onChanged: (v) => setState(() => _referred = v),
            ),
            const SizedBox(height: 16),
            if (showClinic)
              buildDropdown(
                label: 'Clinic',
                selectedValue: _clinic,
                items: clinicLabels,
                onChanged: (v) => setState(() => _clinic = v),
              ),
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
