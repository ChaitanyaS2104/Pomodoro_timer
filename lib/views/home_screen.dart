import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import the new widget you just created
import 'package:pomodoro/views/timer/focus_timer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sign out the user
  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0, // Remove shadow
        centerTitle: true,
        title: Text(
          'POMODORO',
          style: GoogleFonts.pixelifySans(
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOutUser,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        // This adds the thin line below the AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white.withOpacity(0.3), height: 1.0),
        ),
      ),
      body: const Center(
        // Use the new timer widget here
        child: FocusTimer(
          taskName: 'My New Task',
          currentPomodoro: 1,
          totalPomodoros: 4,
          focusDuration: 1,
        ),
      ),
    );
  }
}
