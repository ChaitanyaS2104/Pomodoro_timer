import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/config/app_colors.dart';

class CompletionScreen extends StatelessWidget {
  final String taskName;
  final int pomodorosCompleted;
  final String evolvedPetImage; // Accepts the final image path

  const CompletionScreen({
    super.key,
    required this.taskName,
    required this.pomodorosCompleted,
    required this.evolvedPetImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'POMODORO',
          style: GoogleFonts.pixelifySans(
            color: AppColors.primaryText,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TASK COMPLETED',
                  style: GoogleFonts.pixelifySans(
                    color: AppColors.primaryText,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  taskName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pixelifySans(
                    color: AppColors.secondaryText,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),
                // --- FIX: Changed fit property to crop the image ---
                SizedBox(
                  height: 150,
                  width: 150, // Constraining width helps cover work consistently
                  child: ClipRRect( // Prevents image overflow if not perfectly square
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      evolvedPetImage, // Display the final evolution
                      fit: BoxFit.cover, // This will crop the image to fit
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.pixelifySans(
                      color: AppColors.secondaryText,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Congratulations!\n',
                        style: TextStyle(
                          color: AppColors.highlightRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: 'Your PixelPet has evolved!'),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    // Navigate back to the TaskSetupScreen
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: const Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      'Back to home',
                      style: GoogleFonts.pixelifySans(
                        color: AppColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

