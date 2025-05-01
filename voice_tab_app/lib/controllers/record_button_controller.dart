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
    final newButton = RecordButton(
      text: text,
      path: path,
      color: color,
      mood: mood,
      isAsset: path.startsWith('assets/'),
    );

    _buttons[mood]?.add(newButton);
    if (addToHome) {
      _buttons['home']?.add(newButton);
    }
    notifyListeners();
  }

  List<RecordButton> getButtons(String mood) => _buttons[mood] ?? [];

  void initializeDefaults() {
    if (_buttons['home']!.isEmpty) {
      addButton(
        'happy',
        'Ik zou graag naar buiten willen',
        'assets/audio/happy_default_audio.mp3',
        addToHome: true,
      );
      addButton(
        'sad',
        'Ik voel mij helaas niet zo goed',
        'assets/audio/sad_default_audio.mp3',
        addToHome: true,
      );
      addButton(
        'angry',
        'Kan je daar mee ophouden?',
        'assets/audio/angry_default_audio.mp3',
        addToHome: true,
      );
      addButton(
        'love',
        'Mag ik een knuffel?',
        'assets/audio/love_default_audio.mp3',
        addToHome: true,
      );
    }
  }

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
  final String mood;
  final bool isAsset;

  RecordButton({
    required this.text,
    required this.path,
    required this.color,
    required this.mood,
    this.isAsset = false,
  });
}
