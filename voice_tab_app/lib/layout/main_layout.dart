import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget? child;
  final StatefulNavigationShell? navigationShell;
  final String? activeMood;

  const MainLayout({
    super.key,
    this.child,
    this.navigationShell,
    this.activeMood,
  });

  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri.toString();
    final isRecord = uri.startsWith('/record');
    final selectedIndex = _getSelectedIndex(uri);
    final Widget content =
        navigationShell != null ? navigationShell! : child ?? const SizedBox();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1333),
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA98DF1), Color(0xFFC6A6FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/images/logo-title-white.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          if (isRecord)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodIcon(context, 'happy', uri),
                  _buildMoodIcon(context, 'sad', uri),
                  _buildMoodIcon(context, 'love', uri),
                  _buildMoodIcon(context, 'angry', uri),
                ],
              ),
            ),
          Expanded(child: content),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF120C25),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Icon(
                  Icons.home,
                  size: 36,
                  color:
                      selectedIndex == 0 ? Colors.purpleAccent : Colors.white,
                ),
              ),
              const SizedBox(width: 60),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: Icon(
                  Icons.person,
                  size: 36,
                  color:
                      selectedIndex == 2 ? Colors.purpleAccent : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => context.go('/record'),
        child: Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF5C5CFF), Color(0xFFCB5EFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/nav-btn.png',
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  int _getSelectedIndex(String uri) {
    if (uri.startsWith('/home')) return 0;
    if (uri.startsWith('/profile')) return 2;
    return 1;
  }

  Widget _buildMoodIcon(BuildContext context, String mood, String uri) {
    final isSelected =
        uri == '/record/$mood' || (mood == 'happy' && uri == '/record');
    final asset = 'assets/images/$mood-mood.png';

    return GestureDetector(
      onTap: () => context.go('/record/$mood'),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              isSelected
                  ? Border.all(color: Colors.purpleAccent, width: 3)
                  : null,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 22,
          backgroundImage: AssetImage(asset),
        ),
      ),
    );
  }
}
