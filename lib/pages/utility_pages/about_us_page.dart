import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo at top
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets//logos//logo.jpg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last updated: 1 July 2025',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            buildSectionTitle('Who We Are'),
            const SizedBox(height: 8),
            const Text('''
We are Dr. Rajendra Prasad Centre for Ophthalmology, part of AIIMS, New Delhi.
A national leader in ophthalmic research, patient care, and education.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('Our Mission'),
            const SizedBox(height: 8),
            const Text('''
- Advance eye health through research
- Train future specialists
- Improve patient outcomes through data-driven insights
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('About This App'),
            const SizedBox(height: 8),
            const Text('''
Developed to securely collect and analyze anonymized patient data for research, in full compliance with data protection laws.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('Commitment to Data Protection'),
            const SizedBox(height: 8),
            const Text('''
We comply fully with:
- Constitution of India (Article 21)
- DPDP Act, 2023
- IT Act, 2000
Your data is securely stored and never used for commercial purposes.
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            buildSectionTitle('Contact Us'),
            const SizedBox(height: 8),
            const Text('''
Email: rajeshscomoph@gmail.com

Dr. Rajendra Prasad Centre for Ophthalmology, AIIMS, New Delhi
              ''', style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            buildSectionTitle('Our Team'),
            const SizedBox(height: 8),
            // Grid of team members
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: const [
                TeamMemberWidget(
                  imagePath: 'assets\\images\\team 1.jpg',
                  name: 'Dr. A. Sharma',
                  title: 'Principal Investigator',
                ),
                TeamMemberWidget(
                  imagePath: 'assets\\images\\team 2.jpg',
                  name: 'Dr. B. Verma',
                  title: 'Senior Researcher',
                ),
                TeamMemberWidget(
                  imagePath: 'assets\\images\\team 3.jpg',
                  name: 'Dr. C. Singh',
                  title: 'Clinical Lead',
                ),
                TeamMemberWidget(
                  imagePath: 'assets\\images\\team 4.jpg',
                  name: 'Dr. D. Gupta',
                  title: 'Data Scientist',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Thank you for supporting our mission to advance eye health.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

class TeamMemberWidget extends StatelessWidget {
  final String imagePath;
  final String name;
  final String title;

  const TeamMemberWidget({
    super.key,
    required this.imagePath,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
