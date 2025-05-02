// Bestand: AudioRecorderWidget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_recorder_service.dart';
import 'audio_popup_dialog.dart';
import '../controllers/record_button_controller.dart';

class AudioRecorderWidget extends StatefulWidget {
  final String mood;
  const AudioRecorderWidget({super.key, required this.mood});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final _audioService = AudioRecorderService();
  String? recordedPath;
  Timer? _timer;
  int _secondsLeft = 30;
  bool isRecording = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      final path = await _audioService.startRecording();
      setState(() {
        recordedPath = path;
        isRecording = true;
        _secondsLeft = 30;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft == 0) {
          _stopRecording();
        } else {
          setState(() => _secondsLeft--);
        }
      });
    } catch (e) {
      debugPrint('Opname fout: $e');
    }
  }

  Future<void> _stopRecording() async {
    await _audioService.stopRecording();
    _timer?.cancel();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> _togglePlayback(String path) async {
    if (_audioService.isPlaying) {
      await _audioService.stopPlayback();
    } else {
      await _audioService.play(path);
    }
    setState(() {});
  }

  Future<void> _importAudio() async {
    final path = await _audioService.importAudio();

    if (path == null || path == 'INVALID') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Geen geldig audiobestand gekozen')),
        );
      }
      return;
    }

    setState(() => recordedPath = path);
    _showSavePopup();
  }

  void _showSavePopup() {
    final controller = Provider.of<RecordButtonController>(
      context,
      listen: false,
    );
    final existingTitles =
        controller.getButtons(widget.mood).map((b) => b.text).toList();

    showDialog(
      context: context,
      builder:
          (context) => AudioPopupDialog(
            existingTitles: existingTitles,
            onConfirm: (text, alsoAddToHome) {
              controller.addButton(
                widget.mood,
                text,
                recordedPath!,
                addToHome: alsoAddToHome,
              );
              _resetRecording(); // ✅ Timer reset hier ook na opslaan
              Navigator.of(context).pop();
            },
            onCancel: () {
              _resetRecording();
              Navigator.of(context).pop();
            },
          ),
    );
  }

  void _resetRecording() {
    _timer?.cancel();
    setState(() {
      recordedPath = null;
      isRecording = false;
      _secondsLeft = 30;
    });
  }

  void _confirmDelete(String title) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1333),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.purpleAccent),
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Weet je zeker dat je deze knop wilt verwijderen?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final controller = Provider.of<RecordButtonController>(
                          context,
                          listen: false,
                        );
                        controller.removeButton(widget.mood, title);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Verwijder',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Annuleer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecordButtonController>(context);
    final savedMessages = controller.getButtons(widget.mood);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.file_upload, color: Colors.purpleAccent),
                onPressed: _importAudio,
              ),
              Expanded(
                child: Row(
                  children: [
                    if (recordedPath == null && !isRecording)
                      GestureDetector(
                        onTap: _startRecording,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const Icon(
                              Icons.mic,
                              size: 48,
                              color: Colors.purpleAccent,
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 12,
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (recordedPath != null || isRecording)
                      GestureDetector(
                        onTap: () => _togglePlayback(recordedPath!),
                        child: CircleAvatar(
                          backgroundColor: Colors.purpleAccent,
                          radius: 22,
                          child: Icon(
                            _audioService.isPlaying
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(child: Container(height: 4, color: Colors.white)),
                    const SizedBox(width: 12),
                    Text(
                      '$_secondsLeft s',
                      style: const TextStyle(color: Colors.purpleAccent),
                    ),
                    const SizedBox(width: 8),
                    if (recordedPath != null || isRecording)
                      IconButton(
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.purpleAccent,
                        ),
                        onPressed: _stopRecording,
                      ),
                    if (recordedPath != null && !isRecording)
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.deepPurple),
                        onPressed: _showSavePopup,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Divider(color: Colors.purpleAccent, height: 1),
        const SizedBox(height: 6),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  savedMessages.map((msg) {
                    return GestureDetector(
                      onLongPress: () => _confirmDelete(msg.text),
                      child: ElevatedButton(
                        onPressed: () => _togglePlayback(msg.path),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: msg.color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: const TextStyle(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
