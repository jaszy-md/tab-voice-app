import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_tab_app/layout/main_layout.dart';
import '../views/home/home_page.dart';
import '../views/profile/profile_page.dart';
import '../views/record/record_happy_page.dart';
import '../views/record/record_sad_page.dart';
import '../views/record/record_angry_page.dart';
import '../views/record/record_love_page.dart';

class AppNavigation {
  AppNavigation._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: ProfilePage()),
              ),
            ],
          ),
          // Record + mood pages
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/record',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: RecordHappyPage()),
              ),
              GoRoute(
                path: '/record/happy',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: RecordHappyPage()),
              ),
              GoRoute(
                path: '/record/sad',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: RecordSadPage()),
              ),
              GoRoute(
                path: '/record/angry',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: RecordAngryPage()),
              ),
              GoRoute(
                path: '/record/love',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: RecordLovePage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
