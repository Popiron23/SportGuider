import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [MapRoute(), CoachRoute(), FriendRoute()],
      bottomNavigationBuilder: (_, tabsRouter) {
        final currentIndex = tabsRouter.activeIndex;

        //Дизайн нижней панели
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
                  currentIndex == 0
                      ? AppColors.activeColor
                      : AppColors.unactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Тренеры',
              icon: SvgPicture.asset(
                'assets/images/svg/dribbble.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 1
                      ? AppColors.activeColor
                      : AppColors.unactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Друзья',
              icon: SvgPicture.asset(
                'assets/images/svg/users.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? AppColors.activeColor
                      : AppColors.unactiveColor,
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
