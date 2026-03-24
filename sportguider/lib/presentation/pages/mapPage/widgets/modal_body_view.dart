import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/colors.dart';

class ModalBodyView extends StatelessWidget {
  const ModalBodyView({required this.location});

  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            location.name,
            style: GoogleFonts.philosopher(
              fontSize: 20,
              color: AppColors.activeColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Вид спорта: ${location.sport.ru}',
            style: GoogleFonts.philosopher(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            'Описание: ${location.description ?? ''}',
            style: GoogleFonts.philosopher(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            'Тренеры: ${location.coaches ?? ''}',
            style: GoogleFonts.philosopher(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
