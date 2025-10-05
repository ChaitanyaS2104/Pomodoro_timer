import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/config/app_colors.dart';
import 'package:pomodoro/models/pokemon_family.dart'; // Import the model
import 'package:pomodoro/views/timer/focus_timer.dart';
import 'package:pomodoro/views/completion_screen.dart';

class TaskLog {
  final String name;
  final int pomodorosCompleted;
  final DateTime date;
  final int pomodoroDuration;

  TaskLog({
    required this.name,
    required this.pomodorosCompleted,
    required this.date,
    required this.pomodoroDuration,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'pomodorosCompleted': pomodorosCompleted,
    'date': Timestamp.fromDate(date),
    'pomodoroDuration': pomodoroDuration,
  };

  factory TaskLog.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TaskLog(
      name: data['name'],
      pomodorosCompleted: data['pomodorosCompleted'],
      date: (data['date'] as Timestamp).toDate(),
      pomodoroDuration: data['pomodoroDuration'] ?? 25,
    );
  }

  String get totalTimeString {
    final totalMinutes = pomodorosCompleted * pomodoroDuration;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

class TaskSetupScreen extends StatefulWidget {
  const TaskSetupScreen({super.key});

  @override
  State<TaskSetupScreen> createState() => _TaskSetupScreenState();
}

class _TaskSetupScreenState extends State<TaskSetupScreen> {
  int _selectedPomodoroMinutes = 25;
  int _selectedBreakMinutes = 5;

  final TextEditingController _taskController = TextEditingController(
    text: 'App dev project',
  );
  final TextEditingController _numPomodorosController = TextEditingController(
    text: '4',
  );

  late final CollectionReference<Map<String, dynamic>> _taskLogsCollection;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // --- NEW: Define your Pokemon families using the simplified model ---
  final List<PokemonFamily> _pokemonFamilies = [
    const PokemonFamily(
      name: 'Bulbasaur Line',
      evolutionImages: [
        'assets/bulbasaur.png',
        'assets/ivysaur.png',
        'assets/venusaur.png',
        'assets/venusaur-mega.png',
      ],
    ),
    const PokemonFamily(
      name: 'Larvitar Line',
      evolutionImages: [
        'assets/larvitar.png',
        'assets/pupitar.png',
        'assets/tyranitar.png',
        'assets/tyranitar-mega.png',
      ],
    ),
    const PokemonFamily(
      name: 'Bagon Line',
      evolutionImages: [
        'assets/bagon.png',
        'assets/shelgon.png',
        'assets/salamence.png',
        'assets/salamence-mega.png',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _taskLogsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('taskLogs');
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _numPomodorosController.dispose();
    super.dispose();
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  void _startFocusSession() async {
    final taskName = _taskController.text.trim();
    final totalPomodoros =
        int.tryParse(_numPomodorosController.text.trim()) ?? 4;

    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a task name!',
            style: GoogleFonts.pixelifySans(color: AppColors.background),
          ),
          backgroundColor: AppColors.highlightRed,
        ),
      );
      return;
    }

    final random = Random();
    final selectedPokemonFamily =
        _pokemonFamilies[random.nextInt(_pokemonFamilies.length)];

    final completedPomodoros = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => FocusTimer(
          taskName: taskName,
          totalPomodoros: totalPomodoros,
          focusDuration: _selectedPomodoroMinutes,
          restDuration: _selectedBreakMinutes,
          pokemonFamily: selectedPokemonFamily,
        ),
      ),
    );

    if (completedPomodoros != null && completedPomodoros > 0) {
      await _logCompletedTask(
        taskName,
        completedPomodoros,
        _selectedPomodoroMinutes,
      );

      if (mounted) {
        final finalEvolutionImage = selectedPokemonFamily.evolutionImages.last;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompletionScreen(
              taskName: taskName,
              pomodorosCompleted: completedPomodoros,
              evolvedPetImage: finalEvolutionImage,
            ),
          ),
        );
      }
    }
  }

  Future<void> _logCompletedTask(
    String name,
    int count,
    int pomodoroDuration,
  ) async {
    if (currentUser == null) return;
    final newTaskLog = TaskLog(
      name: name,
      pomodorosCompleted: count,
      date: DateTime.now(),
      pomodoroDuration: pomodoroDuration,
    );
    await _taskLogsCollection.add(newTaskLog.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle inputTextStyle = GoogleFonts.pixelifySans(
      color: AppColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    final TextStyle labelTextStyle = GoogleFonts.pixelifySans(
      color: AppColors.secondaryText,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    final TextStyle headerTextStyle = GoogleFonts.pixelifySans(
      color: AppColors.primaryText,
      fontSize: 28,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('POMODORO', style: headerTextStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: signOutUser,
            icon: const Icon(Icons.logout, color: AppColors.primaryText),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('TASK NAME', style: labelTextStyle),
            const SizedBox(height: 8.0),
            _buildInputField(
              controller: _taskController,
              hintText: 'e.g. Study Calculus',
              textStyle: inputTextStyle,
            ),
            const SizedBox(height: 20.0),
            Text('# OF POMODOROS', style: labelTextStyle),
            const SizedBox(height: 8.0),
            _buildInputField(
              controller: _numPomodorosController,
              hintText: 'e.g. 4',
              keyboardType: TextInputType.number,
              textStyle: inputTextStyle,
            ),
            const SizedBox(height: 20.0),
            Text('POMODORO TIME', style: labelTextStyle),
            const SizedBox(height: 10.0),
            _buildTimeSelector(
              options: [1, 15, 20, 25, 30],
              selectedTime: _selectedPomodoroMinutes,
              onSelected: (time) =>
                  setState(() => _selectedPomodoroMinutes = time),
              textStyle: inputTextStyle,
            ),
            const SizedBox(height: 20.0),
            Text('BREAK TIME', style: labelTextStyle),
            const SizedBox(height: 10.0),
            _buildTimeSelector(
              options: [1, 3, 5],
              selectedTime: _selectedBreakMinutes,
              onSelected: (time) =>
                  setState(() => _selectedBreakMinutes = time),
              textStyle: inputTextStyle,
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startFocusSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'START',
                  style: inputTextStyle.copyWith(
                    color: AppColors.background,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Divider(color: AppColors.secondaryText),
            const SizedBox(height: 20.0),
            Text('TASK LOGS', style: labelTextStyle),
            const SizedBox(height: 15.0),
            _buildTaskLogStream(inputTextStyle, labelTextStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskLogStream(TextStyle inputStyle, TextStyle labelStyle) {
    if (currentUser == null) {
      return Center(
        child: Text('Please log in to see your tasks.', style: labelStyle),
      );
    }
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _taskLogsCollection.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading tasks.', style: labelStyle));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No tasks logged yet.', style: labelStyle));
        }
        final logs = snapshot.data!.docs
            .map((doc) => TaskLog.fromSnapshot(doc))
            .toList();
        return Column(
          children: _buildTaskLogEntries(logs, inputStyle, labelStyle),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required TextStyle textStyle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        border: Border.all(color: AppColors.inputBorder, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextField(
        controller: controller,
        style: textStyle,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle.copyWith(color: AppColors.secondaryText),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required List<int> options,
    required int selectedTime,
    required ValueChanged<int> onSelected,
    required TextStyle textStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((time) {
        final isSelected = time == selectedTime;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: options.last != time ? 8.0 : 0),
            child: SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () => onSelected(time),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.highlightRed
                      : AppColors.inputFill,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  side: BorderSide(color: AppColors.inputBorder, width: 1.0),
                ),
                child: Text('$time', style: textStyle.copyWith(fontSize: 16)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildTaskLogEntries(
    List<TaskLog> logs,
    TextStyle inputStyle,
    TextStyle labelStyle,
  ) {
    return logs.map((log) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: AppColors.inputBorder, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.name, style: inputStyle),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL TIME - ${log.totalTimeString}',
                    style: labelStyle,
                  ),
                  Text(
                    'POMODORO - ${log.pomodorosCompleted}',
                    style: labelStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
