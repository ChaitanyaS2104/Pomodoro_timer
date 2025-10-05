import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sign out the user
  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(
        0xFF2D2D2D,
      ), // Using your app's background color
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'HOME',
          style: GoogleFonts.pixelifySans(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: signOutUser,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'LOGGED IN AS: ${user?.email}',
          style: GoogleFonts.pixelifySans(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
