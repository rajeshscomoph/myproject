import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailOrMobileController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    final input = _emailOrMobileController.text.trim();
    if (input.isEmpty) {
      _showDialog('Please enter your mobile number.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      
      await Future.delayed(const Duration(seconds: 2));

      _showDialog('A reset link has been sent if the account exists.');
    } catch (e) {
      _showDialog('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Enter your mobile number below and we\'ll send you a password reset link.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailOrMobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.mobile_friendly),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _sendResetLink,
                      child: const Text(
                        'Send Reset Link',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

