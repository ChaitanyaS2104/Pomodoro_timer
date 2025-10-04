import 'package:flutter/material.dart';
import 'package:pomodoro/views/onboard.dart';
import 'package:firebase_core/firebase_core.dart'; // Import
import 'firebase_options.dart'; // Import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  await Firebase.initializeApp( // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Onboard());
}
