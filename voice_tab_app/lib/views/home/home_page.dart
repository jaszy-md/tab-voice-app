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
    final homeButtons = controller.getButtons('home');

    return Scaffold(
      backgroundColor: const Color(0xFF271B43),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMoodHeader(context),
              const SizedBox(height: 40),
              const Text(
                'Home Page',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 16),
              FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children:
                      homeButtons.map((msg) {
                        return Focus(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Choose the fitting mood',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodButton(context, 'angry-mood.png', 'angry'),
              _buildMoodButton(context, 'sad-mood.png', 'sad'),
              _buildMoodButton(context, 'happy-mood.png', 'happy'),
              _buildMoodButton(context, 'love-mood.png', 'love'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(
    BuildContext context,
    String asset,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/$routeName');
      },
      child: Image.asset('assets/images/$asset', width: 50, height: 50),
    );
  }
}
