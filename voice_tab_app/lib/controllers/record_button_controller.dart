import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecordButtonController extends ChangeNotifier {
  final Map<String, List<RecordButton>> _buttons = {
    'angry': [],
    'happy': [],
    'love': [],
    'sad': [],
    'home': [],
  };

  RecordButtonController();

  Future<void> loadFromPrefs() async {
    await _loadButtons();

    final allEmpty = _buttons.values.every((list) => list.isEmpty);
    if (allEmpty) {
      initializeDefaults();
    }

    notifyListeners();
  }

  void addButton(
    String mood,
    String text,
    String path, {
    bool addToHome = false,
  }) {
    if (_buttons[mood]?.any((b) => b.text == text) ?? false) return;

    final color = _getColorForMood(mood);
    final newButton = RecordButton(
      text: text,
      path: path,
      color: color,
      mood: mood,
      isAsset: path.startsWith('assets/'),
    );

    _buttons[mood]?.add(newButton);
    if (addToHome && !(_buttons['home']?.any((b) => b.text == text) ?? false)) {
      _buttons['home']?.add(newButton);
    }

    _saveButtons();
    notifyListeners();
  }

  void removeButton(String mood, String title) {
    _buttons[mood]?.removeWhere((b) => b.text == title);
    _buttons['home']?.removeWhere((b) => b.text == title);
    _saveButtons();
    notifyListeners();
  }

  List<RecordButton> getButtons(String mood) => _buttons[mood] ?? [];

  void initializeDefaults() {
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

  Future<void> _saveButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> stored = {};

    _buttons.forEach((mood, list) {
      stored[mood] = jsonEncode(list.map((b) => b.toJson()).toList());
    });

    for (final mood in stored.keys) {
      await prefs.setString('buttons_$mood', stored[mood]!);
    }
  }

  Future<void> _loadButtons() async {
    final prefs = await SharedPreferences.getInstance();

    for (final mood in _buttons.keys) {
      final data = prefs.getString('buttons_$mood');
      if (data != null) {
        final List decoded = jsonDecode(data);
        _buttons[mood] =
            decoded
                .map((e) => RecordButton.fromJson(e))
                .cast<RecordButton>()
                .toList();
      }
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

  Map<String, dynamic> toJson() => {
    'text': text,
    'path': path,
    'color': color.value,
    'mood': mood,
    'isAsset': isAsset,
  };

  factory RecordButton.fromJson(Map<String, dynamic> json) => RecordButton(
    text: json['text'],
    path: json['path'],
    color: Color(json['color']),
    mood: json['mood'],
    isAsset: json['isAsset'],
  );
}
