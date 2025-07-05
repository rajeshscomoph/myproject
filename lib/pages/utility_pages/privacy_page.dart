import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                Icons.privacy_tip,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Privacy Policy',
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
            buildSectionTitle('1. What data do we collect?'),
            const SizedBox(height: 8),
            const Text('''
- Mobile number
- Patient demographic details
- Medical or health data you choose to share
We only collect data that is necessary for research and analysis.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('2. Purpose of data use'),
            const SizedBox(height: 8),
            const Text('''
Your data will only be used for:
- Academic and clinical research
- Improving our services and understanding patient trends
We will never sell, share, or use your data for marketing or unrelated commercial purposes.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('3. How do we protect your data?'),
            const SizedBox(height: 8),
            const Text('''
- Data is encrypted and securely stored
- Access is limited to authorized research personnel only
- We follow industry best practices and government guidelines to avoid unauthorized access, leaks, or misuse
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('4. Your rights'),
            const SizedBox(height: 8),
            const Text('''
Under the DPDP Act, you have the right to:
- Access your personal data
- Correct inaccuracies
- Withdraw consent (where applicable)
- Ask us to delete your data (subject to legal obligations)

To exercise these rights, please contact us at: rajeshscomoph@gmail.com
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('5. Consent'),
            const SizedBox(height: 8),
            const Text('''
By using this app, you consent to:
- The collection and use of your data for research purposes
- Processing and storage as described in this policy
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('6. Updates to this policy'),
            const SizedBox(height: 8),
            const Text('''
We may update this policy to stay compliant with the law or improve transparency.
All changes will be posted within the app.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('Contact'),
            const SizedBox(height: 8),
            const Text('''
If you have any questions, write to us at: rajeshscomoph@gmail.com

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

  /// Helper to build section titles with uniform styling
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
