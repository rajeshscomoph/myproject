import 'package:flutter/material.dart';
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
  String? _wearGlass, _pva1, _pva2, _pvaNear, _diagnosisCode;
  String? _referred, _clinic;

  final TextEditingController _iopReController = TextEditingController();
  final TextEditingController _iopLeController = TextEditingController();
  final TextEditingController _fundNotTakenReasController =
      TextEditingController();
  final TextEditingController _otherMController = TextEditingController();

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
  final List<String> pvaNearLabels = ['Can Read N6', "Can't Read N6"];
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
  bool get showOtherM => (_diagnosisCode?.startsWith('13-') ?? false);
  bool get showClinic =>
      _referred == '1-Referred to RPC' ||
      _referred == '4-Refraction & Referred to RPC';

  @override
  void initState() {
    super.initState();
    _iopReController.addListener(() => setState(() {}));
    _iopLeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _iopReController.dispose();
    _iopLeController.dispose();
    _fundNotTakenReasController.dispose();
    _otherMController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: const Text('Your form has been submitted successfully!'),
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

  Widget buildRadioGroup({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: options
              .map(
                (opt) => ChoiceChip(
                  label: Text(opt, style: const TextStyle(fontSize: 14)),
                  selected: selectedValue == opt,
                  onSelected: (_) => setState(() => onChanged(opt)),
                  selectedColor: Colors.teal.shade700,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: selectedValue == opt ? Colors.white : Colors.black,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(Icons.edit, color: Colors.teal.shade700),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) ? 'Please enter $label' : null,
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }

  Widget buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade800),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      color: Colors.teal.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle(icon, title),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FormPage(
            title: 'Primary Eye Care - Page 2',
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ListView(
                  padding: const EdgeInsets.all(4),
                  children: [
                    if (showExtraFields)
                      buildCard(
                        'Diabetes & Glaucoma Assessment',
                        Icons.medical_information,
                        [
                          buildRadioGroup(
                            title: 'Family History',
                            options: yesNoList,
                            selectedValue: _selectedFamilyHis,
                            onChanged: (v) => _selectedFamilyHis = v,
                          ),
                          buildRadioGroup(
                            title: 'Diabetes',
                            options: yesNoList,
                            selectedValue: _selectedDiabetes,
                            onChanged: (v) => _selectedDiabetes = v,
                          ),
                          if (showIOPFields) ...[
                            buildTextField('IOP_RE', _iopReController),
                            buildTextField('IOP_LE', _iopLeController),
                          ],
                          if (showFundusFields) ...[
                            buildRadioGroup(
                              title: 'Fundus Taken',
                              options: yesNoList,
                              selectedValue: _selectedFundusTaken,
                              onChanged: (v) => _selectedFundusTaken = v,
                            ),
                            if (showFundNotTakenReason)
                              buildTextField(
                                'Fund Not Taken Reason',
                                _fundNotTakenReasController,
                              ),
                          ],
                          if (showGlucomaSusFields) ...[
                            buildRadioGroup(
                              title: 'GlucomaSusRE',
                              options: yesNoList,
                              selectedValue: _selectedGlucomaSusRE,
                              onChanged: (v) => _selectedGlucomaSusRE = v,
                            ),
                            buildRadioGroup(
                              title: 'GlucomaSusLE',
                              options: yesNoList,
                              selectedValue: _selectedGlucomaSusLE,
                              onChanged: (v) => _selectedGlucomaSusLE = v,
                            ),
                          ],
                        ],
                      ),
                    if (showNewOnlyFields)
                      buildCard(
                        'Functionality Assessment',
                        Icons.accessibility,
                        [
                          buildRadioGroup(
                            title: 'Vision',
                            options: difficultyLevels,
                            selectedValue: _vision,
                            onChanged: (v) => _vision = v,
                          ),
                          buildRadioGroup(
                            title: 'Hearing',
                            options: difficultyLevels,
                            selectedValue: _hearing,
                            onChanged: (v) => _hearing = v,
                          ),
                          buildRadioGroup(
                            title: 'Walking',
                            options: difficultyLevels,
                            selectedValue: _walking,
                            onChanged: (v) => _walking = v,
                          ),
                          buildRadioGroup(
                            title: 'Remember',
                            options: difficultyLevels,
                            selectedValue: _remember,
                            onChanged: (v) => _remember = v,
                          ),
                          buildRadioGroup(
                            title: 'Self Care',
                            options: difficultyLevels,
                            selectedValue: _selfCare,
                            onChanged: (v) => _selfCare = v,
                          ),
                          buildRadioGroup(
                            title: 'ComCation',
                            options: difficultyLevels,
                            selectedValue: _comCation,
                            onChanged: (v) => _comCation = v,
                          ),
                        ],
                      ),
                    buildRadioGroup(
                      title: 'Wear Glass',
                      options: yesNoList,
                      selectedValue: _wearGlass,
                      onChanged: (v) => _wearGlass = v,
                    ),
                    buildCard('Presenting Visual Acuity', Icons.visibility, [
                      buildRadioGroup(
                        title: 'PVA1',
                        options: pvaLabels,
                        selectedValue: _pva1,
                        onChanged: (v) => _pva1 = v,
                      ),
                      buildRadioGroup(
                        title: 'PVA2',
                        options: pvaLabels,
                        selectedValue: _pva2,
                        onChanged: (v) => _pva2 = v,
                      ),
                      if (showPvaNear)
                        buildRadioGroup(
                          title: 'PVA Near',
                          options: pvaNearLabels,
                          selectedValue: _pvaNear,
                          onChanged: (v) => _pvaNear = v,
                        ),
                    ]),
                    buildCard(
                      'Assessment / Diagnosis',
                      Icons.medical_services,
                      [
                        buildRadioGroup(
                          title: 'Diagnosis Code',
                          options: diagnosisLabels,
                          selectedValue: _diagnosisCode,
                          onChanged: (v) {
                            _diagnosisCode = v;
                            if (!showOtherM) _otherMController.clear();
                          },
                        ),
                        if (showOtherM)
                          buildTextField('OtherM', _otherMController),
                      ],
                    ),
                    buildCard('Referral Details', Icons.local_hospital, [
                      buildRadioGroup(
                        title: 'Referred',
                        options: referredLabels,
                        selectedValue: _referred,
                        onChanged: (v) => _referred = v,
                      ),
                      if (showClinic)
                        buildCard('Referred Clinic', Icons.medical_services, [
                          buildRadioGroup(
                            title: 'Referred Clinic',
                            options: clinicLabels,
                            selectedValue: _clinic,
                            onChanged: (v) => _clinic = v,
                          ),
                        ]),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          onPressed: _submitForm,
                          icon: const Icon(Icons.check),
                          label: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
