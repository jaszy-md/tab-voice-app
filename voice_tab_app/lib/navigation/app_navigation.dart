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

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Record pages (los van shell, met NoTransitionPage)
      GoRoute(
        path: '/record',
        pageBuilder:
            (context, state) => const NoTransitionPage(
              child: MainLayout(activeMood: 'happy', child: RecordHappyPage()),
            ),
      ),
      GoRoute(
        path: '/record/happy',
        pageBuilder:
            (context, state) => const NoTransitionPage(
              child: MainLayout(activeMood: 'happy', child: RecordHappyPage()),
            ),
      ),
      GoRoute(
        path: '/record/sad',
        pageBuilder:
            (context, state) => const NoTransitionPage(
              child: MainLayout(activeMood: 'sad', child: RecordSadPage()),
            ),
      ),
      GoRoute(
        path: '/record/angry',
        pageBuilder:
            (context, state) => const NoTransitionPage(
              child: MainLayout(activeMood: 'angry', child: RecordAngryPage()),
            ),
      ),
      GoRoute(
        path: '/record/love',
        pageBuilder:
            (context, state) => const NoTransitionPage(
              child: MainLayout(activeMood: 'love', child: RecordLovePage()),
            ),
      ),

      // Home en Profile met StatefulShell + NoTransitionPage
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
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
        ],
      ),
    ],
  );
}
