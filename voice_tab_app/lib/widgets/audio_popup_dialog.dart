// Bestand: audio_popup_dialog.dart
import 'package:flutter/material.dart';

class AudioPopupDialog extends StatefulWidget {
  final Function(String, bool) onConfirm;
  final VoidCallback onCancel;
  final List<String> existingTitles;

  const AudioPopupDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    this.existingTitles = const [],
  });

  @override
  State<AudioPopupDialog> createState() => _AudioPopupDialogState();
}

class _AudioPopupDialogState extends State<AudioPopupDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _handleConfirm(bool addToHome) {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() => _errorText = 'Je moet iets invullen');
      return;
    }

    if (text.length > 35) {
      setState(() => _errorText = 'Maximaal 35 tekens toegestaan');
      return;
    }

    final normalizedInput = text.toLowerCase();
    final normalizedTitles =
        widget.existingTitles.map((t) => t.toLowerCase().trim()).toList();

    if (normalizedTitles.contains(normalizedInput)) {
      setState(() => _errorText = 'Er bestaat al een knop met deze naam');
      return;
    }

    setState(() => _errorText = null);
    widget.onConfirm(text, addToHome);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1333),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Voer een titel in:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: 'Type hier...',
              hintStyle: const TextStyle(color: Colors.white54),
              errorText: _errorText,
              errorStyle: const TextStyle(color: Colors.redAccent),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _popupButton(
                Icons.check,
                Colors.green,
                () => _handleConfirm(false),
              ),
              _popupButton(Icons.close, Colors.red, widget.onCancel),
              _popupButton(
                Icons.add_home,
                Colors.purpleAccent,
                () => _handleConfirm(true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // s
  Widget _popupButton(IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
