import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/config/app_colors.dart';
import 'package:pomodoro/views/timer/rest_timer.dart';

class FocusTimer extends StatefulWidget {
  final String taskName;
  final int currentPomodoro;
  final int totalPomodoros;
  final int focusDuration; // Time in minutes

  const FocusTimer({
    super.key,
    required this.taskName,
    required this.currentPomodoro,
    required this.totalPomodoros,
    required this.focusDuration,
  });

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

// Add 'with TickerProviderStateMixin' for the AnimationController
class _FocusTimerState extends State<FocusTimer> with TickerProviderStateMixin {
  late int _initialTimeInSeconds;
  AnimationController? _controller; // Use AnimationController instead of Timer

  final List<String> _pixelPets = [
    'assets/shelgon.png',
    'assets/bulbasaur.png',
    'assets/larvitar.png',
  ];

  late String _selectedPetAsset;

  @override
  void initState() {
    super.initState();
    _initialTimeInSeconds = widget.focusDuration * 60;
    _selectRandomPet();

    // Initialize the AnimationController
    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(seconds: _initialTimeInSeconds),
        )..addListener(() {
          // This setState call is efficient, only rebuilding when the animation value changes
          setState(() {});
        });

    // Add a listener to know when the timer completes
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        // This is called when the timer reaches 0
        _navigateToRest();
      }
    });
  }

  void _navigateToRest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestTimer(
          taskName: widget.taskName,
          currentPomodoro:
              widget.currentPomodoro, // Pomodoro count updates after rest
          totalPomodoros: widget.totalPomodoros,
          restDuration: 5, // Default 5 minute rest
        ),
      ),
    ).then((_) {
      // This code runs when we return from the RestTimer screen
      // It prepares the timer for the *next* pomodoro session
      // We now call a modified restart that doesn't auto-play
      _resetTimerForNextRound();
    });
  }

  void _selectRandomPet() {
    final random = Random();
    _selectedPetAsset = _pixelPets[random.nextInt(_pixelPets.length)];
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  void _toggleTimer() {
    // --- FIX: Wrap in setState to update the icon ---
    setState(() {
      if (_controller?.isAnimating ?? false) {
        _stopTimer();
      } else {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    // Reverse the animation from 1.0 (full) to 0.0 (empty)
    _controller?.reverse(
      from: _controller!.value == 0.0 ? 1.0 : _controller!.value,
    );
  }

  void _stopTimer() {
    _controller?.stop();
  }

  // --- RENAMED and CORRECTED RESTART FUNCTION ---
  void _resetTimerForNextRound() {
    // This is called when returning from the rest screen.
    // It resets the timer to full and leaves it paused.
    setState(() {
      _controller?.value = 1.0;
    });
  }

  void _restartTimer() {
    // This is for the user-facing restart button.
    // It resets the timer to full and leaves it paused.
    setState(() {
      _controller?.stop();
      _controller?.value = 1.0;
    });
  }

  String get _formattedTime {
    if (_controller == null) return "00 : 00";
    // Calculate time left from the controller's value
    final timeLeftInSeconds = (_controller!.value * _initialTimeInSeconds)
        .round();
    final minutes = (timeLeftInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeLeftInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          Text(
            'FOCUS TIME',
            style: GoogleFonts.pixelifySans(
              color: AppColors.secondaryText,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.taskName, // Dynamic task name
                style: GoogleFonts.pixelifySans(
                  color: AppColors.secondaryText,
                  fontSize: 20,
                ),
              ),
              Text(
                '${widget.currentPomodoro} / ${widget.totalPomodoros}', // Dynamic count
                style: GoogleFonts.pixelifySans(
                  color: AppColors.secondaryText,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  // Use the controller's value for the progress
                  value: _controller?.value ?? 1.0,
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accent,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  _selectedPetAsset, // Randomly selected pet image
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            _formattedTime,
            style: GoogleFonts.pixelifySans(
              color: AppColors.primaryText,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _toggleTimer,
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    (_controller?.isAnimating ?? false)
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: AppColors.background,
                    size: 45,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: _restartTimer,
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.highlightRed,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.replay,
                    color: AppColors.background,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.highlightRed, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            child: Text(
              'Stay Focused to evolve your PixelPet!',
              textAlign: TextAlign.center,
              style: GoogleFonts.pixelifySans(
                color: AppColors.highlightRed,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
