import 'package:flutter/material.dart';

class RecordButtonController extends ChangeNotifier {
  final Map<String, List<RecordButton>> _buttons = {
    'angry': [],
    'happy': [],
    'love': [],
    'sad': [],
    'home': [],
  };

  void addButton(
    String mood,
    String text,
    String path, {
    bool addToHome = false,
  }) {
    final color = _getColorForMood(mood);
    final newButton = RecordButton(text: text, path: path, color: color);
    _buttons[mood]?.add(newButton);
    if (addToHome) {
      _buttons['home']?.add(newButton);
    }
    notifyListeners();
  }

  List<RecordButton> getButtons(String mood) => _buttons[mood] ?? [];

  Color _getColorForMood(String mood) {
    switch (mood) {
      case 'angry':
        return Colors.redAccent;
      case 'happy':
        return Colors.yellowAccent;
      case 'love':
        return Colors.pinkAccent;
      case 'sad':
        return Colors.blueAccent;
      default:
        return Colors.purpleAccent;
    }
  }
}

class RecordButton {
  final String text;
  final String path;
  final Color color;

  RecordButton({required this.text, required this.path, required this.color});
}
