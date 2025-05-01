import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_tab_app/controllers/record_button_controller.dart';
import 'package:voice_tab_app/services/audio_recorder_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _audioService = AudioRecorderService();
  String? _selectedMoodFilter;

  Future<void> _togglePlayback(String path) async {
    if (_audioService.isPlaying) {
      await _audioService.stopPlayback();
    }
    await _audioService.play(path);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecordButtonController>(context);
    final allButtons = controller.getButtons('home');
    final homeButtons =
        _selectedMoodFilter == null
            ? allButtons
            : allButtons
                .where((btn) => btn.mood == _selectedMoodFilter)
                .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF271B43),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 510),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purpleAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Kies een stemming om te filteren',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  _buildMoodIcon('happy'),
                                  _buildMoodIcon('sad'),
                                  _buildMoodIcon('love'),
                                  _buildMoodIcon('angry'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedMoodFilter = null);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedMoodFilter == null
                                ? Colors.purpleAccent
                                : Colors.white24,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Show All'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        homeButtons.map((msg) {
                          return ElevatedButton(
                            onPressed: () => _togglePlayback(msg.path),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: msg.color,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
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
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String mood) {
    final isSelected = _selectedMoodFilter == mood;
    final asset = 'assets/images/$mood-mood.png';

    return GestureDetector(
      onTap: () {
        setState(() => _selectedMoodFilter = mood);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              isSelected
                  ? Border.all(color: Colors.purpleAccent, width: 3)
                  : null,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          backgroundImage: AssetImage(asset),
        ),
      ),
    );
  }
}
