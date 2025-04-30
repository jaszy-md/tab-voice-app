import 'package:flutter/material.dart';
import '../../widgets/audio_recorder_widget.dart';

class RecordAngryPage extends StatelessWidget {
  const RecordAngryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF271B43),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(height: 12),
              AudioRecorderWidget(mood: 'angry'),
            ],
          ),
        ),
      ),
    );
  }
}
