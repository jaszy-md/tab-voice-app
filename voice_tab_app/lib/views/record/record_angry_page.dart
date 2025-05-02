import 'package:flutter/material.dart';
import '../../widgets/audio_recorder_widget.dart';

class RecordAngryPage extends StatelessWidget {
  const RecordAngryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF271B43),
      body: SafeArea(child: AudioRecorderWidget(mood: 'angry')),
    );
  }
}
