import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/views/registration_screen.dart';
import 'package:pomodoro/theme/app_colors.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the background color for the entire app
        scaffoldBackgroundColor: const Color(0xFF2D2D2D),
        // Set the base font family
        fontFamily: GoogleFonts.pixelifySans().fontFamily,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Distributes space evenly
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // This SizedBox is a placeholder to push content down a bit,
              // adjust or remove as needed.
              const SizedBox(height: 20),

              // ## Title Section ##
              Column(
                children: [
                  Text(
                    'POMODORO',
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.primaryText,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    'TIMER',
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 20),
                  // ## Image Added Here ##
                  Image.asset(
                    'assets/pomodoro_logo.png', // <-- Make sure this path is correct
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    fit: BoxFit.contain, // Ensures the entire image is visible
                  ),
                ],
              ),

              // ## Info Text Section ##
              Column(
                children: [
                  _buildInfoText(
                    'Boost Focus with the Pomodoro technique!',
                    AppColors.secondaryText,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoText(
                    'Work in short, focused sessions with breaks in between.',
                    AppColors.secondaryText,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoText(
                    'Complete sessions to evolve your PixelPet and watch it grow as you stay productive!',
                    AppColors.secondaryText,
                  ),
                ],
              ),

              // ## Get Started Button ##
              SizedBox(
                width: double.infinity, // Make button take full width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // Slight rounding
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    elevation: 0, // No shadow
                  ),
                  child: Text(
                    'GET STARTED!',
                    style: GoogleFonts.pixelifySans(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // This SizedBox is a placeholder to balance the space,
              // adjust or remove as needed.
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to reduce code repetition for the info text
  Widget _buildInfoText(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.pixelifySans(
        color: color,
        fontSize: 18,
        height: 1.5, // Line height
      ),
    );
  }
}
