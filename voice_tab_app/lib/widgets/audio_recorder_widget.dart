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
    _audioService.dispose();
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

    if (path == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Toegang geweigerd of geen bestand gekozen'),
          ),
        );
      }
      return;
    }

    setState(() => recordedPath = path);
    _showSavePopup();
  }

  void _showSavePopup() {
    showDialog(
      context: context,
      builder:
          (context) => AudioPopupDialog(
            onConfirm: (text, alsoAddToHome) {
              final controller = Provider.of<RecordButtonController>(
                context,
                listen: false,
              );
              controller.addButton(
                widget.mood,
                text,
                recordedPath!,
                addToHome: alsoAddToHome,
              );
              setState(() => recordedPath = null);
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
    setState(() {
      recordedPath = null;
      isRecording = false;
      _secondsLeft = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecordButtonController>(context);
    final savedMessages = controller.getButtons(widget.mood);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
          const SizedBox(height: 10),
          Container(height: 4, color: Colors.purpleAccent),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  savedMessages
                      .map(
                        (msg) => ElevatedButton(
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
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
