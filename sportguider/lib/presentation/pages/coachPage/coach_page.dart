import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/search_button.dart';
@RoutePage()
class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
        children: [
          Container(
          color: Colors.white,
        ),

        // Текст "Тренеры"
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Тренеры',
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
            right:10,
            child: SearchButton()
          ),
        

        //Заготовка для будущего списка тренеров
        Column(
          children: [

        ],
        )
        ]
      )
      )
    );
  }
}
