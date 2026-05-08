import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<dynamic>? _authSub;
  bool _showFriends = false;

  @override
  void initState() {
    super.initState();
    _authSub = FirebaseService.auth.authStateChanges().listen((_) => _updateVisibility());
    _updateVisibility();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _updateVisibility() async {
    final user = FirebaseService.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _showFriends = false);
      return;
    }
    final snapshot = await DatabaseService().read(path: 'Coaches/${user.uid}');
    final isCoach = snapshot != null && snapshot.value != null;
    if (mounted) setState(() => _showFriends = !isCoach);
  }

  @override
  Widget build(BuildContext context) {
    final routes = [
      MapRoute(),
      CoachRoute(),
      if (_showFriends) FriendRoute(),
    ];

    return AutoTabsScaffold(
      routes: routes,
      bottomNavigationBuilder: (_, tabsRouter) {
        final currentIndex = tabsRouter.activeIndex;

        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.activeColor,
          unselectedItemColor: AppColors.unactiveColor,
          currentIndex: currentIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Карты',
              icon: SvgPicture.asset(
                'assets/images/svg/map.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 0 ? AppColors.activeColor : AppColors.unactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Тренеры',
              icon: SvgPicture.asset(
                'assets/images/svg/dribbble.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 1 ? AppColors.activeColor : AppColors.unactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (_showFriends)
              BottomNavigationBarItem(
                label: 'Друзья',
                icon: SvgPicture.asset(
                  'assets/images/svg/users.svg',
                  colorFilter: ColorFilter.mode(
                    currentIndex == 2 ? AppColors.activeColor : AppColors.unactiveColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
