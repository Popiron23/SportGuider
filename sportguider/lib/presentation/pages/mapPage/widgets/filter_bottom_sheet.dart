import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/presentation/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<Sport> _selectedSportTypes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Фильтры',
                style: GoogleFonts.philosopher(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,

                child: Text(
                  'Сбросить все',
                  style: GoogleFonts.philosopher(color: AppColors.activeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Фильтр по виду спорта
          Text(
            'Вид спорта',
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildSportTypeGrid(),
          const SizedBox(height: 24),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Отмена',
                    style: GoogleFonts.philosopher(
                      color: AppColors.activeColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Применить',
                    style: GoogleFonts.philosopher(
                      color: AppColors.activeColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSportTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: Sport.values.length,
      itemBuilder: (context, index) {
        final sport = Sport.values[index];
        final isSelected = _selectedSportTypes.contains(sport);

        return FilterChip(
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sport.icon, size: isSelected ? 0 : 40),
              const SizedBox(height: 4),
              Text(
                sport.ru,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedSportTypes.add(sport);
              } else {
                _selectedSportTypes.remove(sport);
              }
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.grey[100],
          selectedColor: Colors.blue[100],
          checkmarkColor: Colors.blue,
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSportTypes = [];
    });
  }
}
