import 'package:flutter/material.dart';

class AudioPopupDialog extends StatefulWidget {
  final Function(String, bool) onConfirm;
  final VoidCallback onCancel;

  const AudioPopupDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<AudioPopupDialog> createState() => _AudioPopupDialogState();
}

class _AudioPopupDialogState extends State<AudioPopupDialog> {
  final TextEditingController _controller = TextEditingController();

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
        children: [
          const Text('Button text:', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Type hier...',
              hintStyle: TextStyle(color: Colors.white54),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _popupButton(Icons.check, Colors.green, () {
                widget.onConfirm(_controller.text, false);
              }),
              const SizedBox(width: 8),
              _popupButton(Icons.close, Colors.red, widget.onCancel),
              const SizedBox(width: 8),
              _popupButton(Icons.add_home, Colors.purpleAccent, () {
                widget.onConfirm(_controller.text, true);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _popupButton(IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }
}
