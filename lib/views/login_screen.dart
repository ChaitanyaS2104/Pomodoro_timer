import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Top spacing
              // ## Title Section ##
              Text(
                'POMODORO',
                style: GoogleFonts.pixelifySans(
                  color: AppColors.primaryText,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'GET STARTED !',
                style: GoogleFonts.pixelifySans(
                  color: AppColors.accent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 60),

              // ## Email Field ##
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'EMAIL',
                  style: GoogleFonts.pixelifySans(
                    color: AppColors.primaryText,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'jane_doe@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // ## Password Field ##
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PASSWORD',
                  style: GoogleFonts.pixelifySans(
                    color: AppColors.primaryText,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: '********',
                obscureText: true,
              ),
              const SizedBox(height: 40),

              // ## Login Button ##
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final String email = _emailController.text.trim();
                      final String password = _passwordController.text.trim();

                      // Validate the inputs are not empty
                      if (email.isEmpty || password.isEmpty) {
                        throw FirebaseAuthException(
                          code: 'fields-empty',
                          message: 'Please enter both email and password.',
                        );
                      }

                      // Sign in the user with Firebase
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // On success, the AuthGate will automatically navigate to the HomeScreen.
                      // We don't need to do anything here.
                    } on FirebaseAuthException catch (e) {
                      // If an error occurs, show a message to the user
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message ?? 'Failed to log in'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.highlightRed, // Use red color from AppColors
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.primaryText, // Text color for the button
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ## Don't have an account? Register ##
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register',
                      style: GoogleFonts.pixelifySans(
                        color: AppColors
                            .highlightRed, // Use red color from AppColors
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.highlightRed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  // This helper widget is identical to the one in RegistrationScreen.
  // For larger apps, you would move this to a shared widgets file.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.pixelifySans(color: AppColors.primaryText),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.pixelifySans(color: AppColors.secondaryText),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
