import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.description,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Effective Date: 1 July 2025',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            buildSectionTitle('1. Legal Framework'),
            const SizedBox(height: 8),
            const Text('''
This app is developed and operated by Dr. Rajendra Prasad Centre for Ophthalmology, AIIMS, New Delhi. We comply with all applicable Indian laws, including but not limited to:
- The Constitution of India, particularly Article 21 (Right to Privacy)
- The Information Technology Act, 2000 and IT Rules
- The Digital Personal Data Protection Act, 2023 (DPDP Act)
- Relevant medical research and ethical guidelines
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('2. Acceptance of Terms'),
            const SizedBox(height: 8),
            const Text('''
By accessing or using this app, you acknowledge and agree to be legally bound by these Terms & Conditions. If you do not agree, please do not use the app.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('3. Purpose of the App'),
            const SizedBox(height: 8),
            const Text('''
This app is intended solely for academic, clinical research, and healthcare improvement purposes. It is not a substitute for professional medical advice, diagnosis, or treatment.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('4. User Responsibilities'),
            const SizedBox(height: 8),
            const Text('''
As a user, you agree to:
- Provide true, accurate, and complete information.
- Use the app only for lawful and ethical purposes.
- Maintain confidentiality of any login credentials.
- Refrain from attempting to hack, alter, or misuse the app or data.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('5. User Rights'),
            const SizedBox(height: 8),
            const Text('''
In accordance with the DPDP Act and Indian law, you have the right to:
- Access your personal data collected by us.
- Request correction of inaccurate data.
- Withdraw consent (subject to legal and ethical obligations).
- Request deletion of data, where applicable.
To exercise these rights, please contact us at: rajeshscomoph@gmail.com
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('6. Data Protection & Privacy'),
            const SizedBox(height: 8),
            const Text('''
We are committed to safeguarding your data:
- All data is securely stored and encrypted.
- Access is limited to authorized research personnel.
- Data will only be used for research and analysis, as outlined in our Privacy Policy.
- We will never sell or misuse your data.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('7. Limitation of Liability'),
            const SizedBox(height: 8),
            const Text('''
While we strive for accuracy and security, we do not guarantee uninterrupted or error-free service.
We shall not be liable for any direct, indirect, incidental, or consequential damages arising from use of the app.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('8. Changes to Terms'),
            const SizedBox(height: 8),
            const Text('''
We reserve the right to modify these Terms & Conditions to reflect changes in law or operational needs.
Any updates will be posted within the app. Continued use constitutes acceptance of the revised terms.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('9. Governing Law & Jurisdiction'),
            const SizedBox(height: 8),
            const Text('''
These Terms & Conditions are governed by and construed in accordance with the laws of India.
Any disputes shall be subject to the exclusive jurisdiction of the courts in New Delhi.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('10. Contact'),
            const SizedBox(height: 8),
            const Text('''
For any questions, requests, or complaints, please contact us at:
rajeshscomoph@gmail.com

Dr. Rajendra Prasad Centre for Ophthalmology, AIIMS, New Delhi
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Last updated: 1 July 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build section titles
  static Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
