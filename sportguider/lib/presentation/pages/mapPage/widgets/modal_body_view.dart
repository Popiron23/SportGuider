import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/colors.dart';

class ModalBodyView extends StatelessWidget {
  const ModalBodyView({required this.location});

  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
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
            '${location.latitude}, ${location.longitude}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
