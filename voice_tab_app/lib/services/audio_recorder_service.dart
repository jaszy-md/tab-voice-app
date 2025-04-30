import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class AudioRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microfoon niet toegestaan');
    }

    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<String> startRecording() async {
    await init();

    final dir = await getApplicationDocumentsDirectory(); // permanente opslag
    final filePath = '${dir.path}/${const Uuid().v4()}.aac';

    await _recorder.startRecorder(toFile: filePath, codec: Codec.aacADTS);

    return filePath;
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
  }

  Future<void> play(String path, {double volume = 2}) async {
    await _player.stop();

    try {
      if (path.startsWith('assets/')) {
        // ✅ Asset audio-bestand afspelen
        await _player.setAsset(path);
      } else {
        // ✅ Lokale opname afspelen
        final file = File(path);
        if (!file.existsSync()) {
          print('Audio bestand niet gevonden: $path');
          return;
        }
        await _player.setFilePath(path);
      }

      _player.setVolume(volume);
      await _player.play();
    } catch (e) {
      print('Fout bij afspelen van $path: $e');
    }
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }

  bool get isRecording => _recorder.isRecording;
  bool get isPlaying => _player.playing;

  Future<String?> importAudio() async {
    bool granted = false;

    if (Platform.isAndroid) {
      if (await Permission.audio.request().isGranted ||
          await Permission.storage.request().isGranted) {
        granted = true;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      if (await Permission.mediaLibrary.request().isGranted) {
        granted = true;
      }
    }

    if (!granted) return null;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aac', 'm4a', 'mp3', 'wav'],
    );

    final path = result?.files.single.path;
    if (path == null) return null;

    final validExtensions = ['aac', 'm4a', 'mp3', 'wav'];
    final extension = path.split('.').last.toLowerCase();

    if (!validExtensions.contains(extension)) {
      return 'INVALID';
    }

    return path;
  }
}
