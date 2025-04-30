import 'package:flutter/material.dart';
import 'package:voice_tab_app/widgets/audio_recorder_widget.dart';

class HomePage extends StatefulWidget {
  static final List<Map<String, dynamic>> homeMessages = [];

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children:
                    HomePage.homeMessages.map((msg) {
                      return ElevatedButton(
                        onPressed: () async {
                          // Add playback service here if needed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: msg['color'],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          msg['text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
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
