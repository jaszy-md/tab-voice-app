import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1333),
      body: Column(
        children: [
          // Header
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

          // content
          Expanded(child: widget.navigationShell),
        ],
      ),
      // Bottom Nav Bar
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF120C25),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                iconSize: 54,
                icon: Icon(
                  Icons.home,
                  color:
                      selectedIndex == 0 ? Colors.purpleAccent : Colors.white,
                ),
                onPressed: () {
                  setState(() => selectedIndex = 0);
                  _goBranch(0);
                },
              ),
              const SizedBox(width: 60),
              IconButton(
                iconSize: 32,
                icon: Icon(
                  Icons.person,
                  color:
                      selectedIndex == 2 ? Colors.purpleAccent : Colors.white,
                ),
                onPressed: () {
                  setState(() => selectedIndex = 2);
                  _goBranch(2);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
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
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            context.go('/record');
            setState(() => selectedIndex = 1);
          },
          child: Image.asset(
            'assets/images/nav-btn.png',
            width: 75,
            height: 75,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
