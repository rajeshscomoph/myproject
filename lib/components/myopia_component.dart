import 'package:flutter/material.dart';

class MyopiaComponent extends StatefulWidget {
  const MyopiaComponent({super.key});

  @override
  State<MyopiaComponent> createState() => _MyopiaComponentState();
}

class _MyopiaComponentState extends State<MyopiaComponent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _opdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _opdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String opdNumber = _opdController.text.trim();
      String name = _nameController.text.trim();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: Text('OPD Number: $opdNumber\nName: $name'),
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

  @override
  Widget build(BuildContext context) {
    return  ListView(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Please fill the details below:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // OPD Number
              TextFormField(
                controller: _opdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OPD Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter OPD Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
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
          );
  }
}
