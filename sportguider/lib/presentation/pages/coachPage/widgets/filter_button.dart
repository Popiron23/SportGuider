import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/filter_bottom_sheet.dart';

class CoachFilterButton extends StatelessWidget {
  const CoachFilterButton({
    super.key,
    required this.initialSportTypes,
    required this.onApply,
  });

  final List<Sport> initialSportTypes;
  final ValueChanged<List<Sport>> onApply;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showFilterBottomSheet(context),
      backgroundColor: AppColors.activeColor,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/filter.svg',
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: FilterBottomSheet(
                initialSportTypes: initialSportTypes,
                onApply: onApply,
              ),
            );
          },
        );
      },
    );
  }
}
