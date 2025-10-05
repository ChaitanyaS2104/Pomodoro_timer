import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/theme/app_colors.dart';
import 'package:pomodoro/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

// (Your main.dart setup should still be the same, assuming MyApp is defined
// with the ScaffoldBackgroundColor and base fontFamily)

class RegistrationScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegistrationScreen({super.key, required this.onTap});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
          // Use SingleChildScrollView to prevent overflow on small screens/keyboard
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
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

              const SizedBox(height: 60), // Space before form fields
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
                inputBorderColor: AppColors.inputBorder,
                focusedInputBorderColor: AppColors.inputFocusedBorder,
                accentColor: AppColors.accent,
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
                inputBorderColor: AppColors.inputBorder,
                focusedInputBorderColor: AppColors.inputFocusedBorder,
                accentColor: AppColors.accent,
              ),
              const SizedBox(height: 40),

              // ## Register Button ##
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Inside the Login Button's onPressed:
                  onPressed: () async {
                    final String email = _emailController.text.trim();
                    final String password = _passwordController.text.trim();

                    // Always a good idea to check for empty fields first
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter both email and password.',
                          ),
                        ),
                      );
                      return; // Stop the function
                    }

                    try {
                      // Use the correct function for registration
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                      // After successful registration, you can navigate to the next screen
                      // or show a success message.
                      print('Registration successful!');
                    } on FirebaseAuthException catch (e) {
                      // Handle specific Firebase errors (like email already in use)
                      print('Failed to register: ${e.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to register: ${e.message}'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.pixelifySans(
                      color: Colors.black, // Text color for the button
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ## Already have an account? Login ##
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login',
                      style: GoogleFonts.pixelifySans(
                        color:
                            Colors.red[300], // A subtle red/pink for the link
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red[300],
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

  // Helper widget to build the custom styled TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required Color inputBorderColor,
    required Color focusedInputBorderColor,
    required Color accentColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.pixelifySans(color: Colors.white), // Input text color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.pixelifySans(color: AppColors.secondaryText),
        filled: true,
        fillColor: const Color(
          0xFF3A3A3A,
        ), // Slightly lighter grey for input background
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputBorderColor, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ), // Accent color when focused
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
