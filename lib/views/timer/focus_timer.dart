import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/config/app_colors.dart';
import 'package:pomodoro/models/pokemon_family.dart';
import 'package:pomodoro/views/timer/rest_timer.dart';

class FocusTimer extends StatefulWidget {
  final String taskName;
  final int totalPomodoros;
  final int focusDuration;
  final int restDuration;
  final PokemonFamily pokemonFamily;

  const FocusTimer({
    super.key,
    required this.taskName,
    required this.totalPomodoros,
    required this.focusDuration,
    required this.restDuration,
    required this.pokemonFamily,
  });

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> with TickerProviderStateMixin {
  late int _initialTimeInSeconds;
  AnimationController? _controller;
  late int _currentPomodoro;

  @override
  void initState() {
    super.initState();
    _currentPomodoro = 1;
    _initialTimeInSeconds = widget.focusDuration * 60;

    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(seconds: _initialTimeInSeconds),
        )..addListener(() {
          setState(() {});
        });

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _handleSessionCompletion();
      }
    });
  }

  void _handleSessionCompletion() {
    if (_currentPomodoro >= widget.totalPomodoros) {
      Navigator.of(context).pop(_currentPomodoro);
    } else {
      Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => RestTimer(
            taskName: widget.taskName,
            currentPomodoro: _currentPomodoro,
            totalPomodoros: widget.totalPomodoros,
            restDuration: widget.restDuration,
            pokemonFamily: widget.pokemonFamily, // Pass family to rest timer
          ),
        ),
      ).then((_) {
        setState(() {
          _currentPomodoro++;
        });
        _restartTimer();
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      if (_controller?.isAnimating ?? false) {
        _stopTimer();
      } else {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _controller?.reverse(
      from: _controller!.value == 0.0 ? 1.0 : _controller!.value,
    );
  }

  void _stopTimer() {
    _controller?.stop();
  }

  void _restartTimer() {
    _controller?.value = 1.0;
  }

  String get _formattedTime {
    if (_controller == null) return "00 : 00";
    final timeLeftInSeconds = (_controller!.value * _initialTimeInSeconds)
        .round();
    final minutes = (timeLeftInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeLeftInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  String get _currentPokemonImage {
    int imageIndex =
        (_currentPomodoro - 1) % widget.pokemonFamily.evolutionImages.length;
    return widget.pokemonFamily.evolutionImages[imageIndex];
  }

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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
                  widget.taskName,
                  style: GoogleFonts.pixelifySans(
                    color: AppColors.secondaryText,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '$_currentPomodoro / ${widget.totalPomodoros}',
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
                    value: _controller?.value ?? 1.0,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accent,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // --- FIX: Applied cropping fix ---
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      _currentPokemonImage,
                      fit: BoxFit.cover, // This crops the image
                    ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
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
      ),
    );
  }
}
