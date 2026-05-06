import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/search_button.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/filter_button.dart';

@RoutePage()
class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),

            // Текст "Тренеры"
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Друзья',
                  style: GoogleFonts.philosopher(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.activeColor,
                  ),
                ),
              ),
            ),

            //Виджет-кнопка "Поиск"
            Positioned(
              top: 5,
              right: 10,
              child: Row(
                children: [
                  CoachFilterButton(
                    initialSportTypes: const <Sport>[],
                    onApply: (_) {},
                  ),
                  const SizedBox(width: 10),
                  SearchButton(),
                ],
              ),
            ),

            //Заготовка для будущего списка тренеров
            Column(children: [

        ],
        ),
          ],
        ),
      ),
    );
  }
}
