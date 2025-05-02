import 'package:flutter/material.dart';
import '../../widgets/audio_recorder_widget.dart';

class RecordSadPage extends StatelessWidget {
  const RecordSadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF271B43),
      body: SafeArea(child: AudioRecorderWidget(mood: 'sad')),
    );
  }
}
