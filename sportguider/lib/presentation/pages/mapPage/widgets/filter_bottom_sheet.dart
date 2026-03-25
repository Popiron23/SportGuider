import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/presentation/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(List<Sport> selectedFilters) onApply;
  final List<Sport> initialSportTypes;
  const FilterBottomSheet({
    super.key,
    required this.onApply,
    required this.initialSportTypes,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<Sport> _selectedSportTypes;
  @override
  void initState() {
    _selectedSportTypes = List.of(widget.initialSportTypes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
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
                  onPressed: () => {
                    widget.onApply(_selectedSportTypes),
                    Navigator.pop(context),
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.activeColor,
                  ),
                  child: Text(
                    'Применить',
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      backgroundColor: AppColors.activeColor,
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
          checkmarkColor: AppColors.activeColor,
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
