import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportguider/presentation/bloc/locations_bloc.dart';
import 'package:sportguider/presentation/bloc/locations_event.dart';
import 'package:sportguider/presentation/bloc/locations_state.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/filter_bottom_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showFilterBottomSheet(context);
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/filter.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}

void _showFilterBottomSheet(BuildContext context1) => showModalBottomSheet(
  context: context1,
  isScrollControlled: true, // Обязательно для draggable
  backgroundColor: Colors.transparent, // Прозрачный фон
  builder: (BuildContext context) {
    return BlocProvider.value(
      value: context1.read<LocationsBloc>(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8, // Начальный размер (30% экрана)
        minChildSize: 0.2, // Минимальный размер (20% экрана)
        maxChildSize: 0.9, // Максимальный размер (90% экрана)
        expand: false, // Не занимать весь экран
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: BlocBuilder<LocationsBloc, LocationsState>(
              builder: (context, state) => FilterBottomSheet(
                initialSportTypes: state.sports,
                onApply: (selectedFilters) {
                  context1.read<LocationsBloc>().add(
                    LocationsUpdateEvent(selectedFilters),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  },
);
