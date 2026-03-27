import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/bloc/locations_bloc.dart';
import 'package:sportguider/presentation/bloc/locations_state.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({
    super.key,
    required this.mapController,
    required this.onPlaceSelected,
  });

  final YandexMapController mapController;
  final void Function(LocationEntity) onPlaceSelected;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LocationEntity> _filter(List<LocationEntity> locations) {
    if (_query.isEmpty) return locations;
    final q = _query.toLowerCase();
    return locations.where((loc) {
      final nameMatch = loc.name.toLowerCase().contains(q);
      final addressMatch = loc.address?.toLowerCase().contains(q) ?? false;
      return nameMatch || addressMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: GoogleFonts.philosopher(
              fontSize: 16,
              color: AppColors.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: 'Поиск мест...',
              hintStyle: GoogleFonts.philosopher(
                fontSize: 16,
                color: AppColors.textSecondaryColor,
              ),
              prefixIcon: Icon(Icons.search, color: AppColors.activeColor),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.textSecondaryColor),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.softBlueColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              if (state is LocationsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LocationsErrorState) {
                return Center(
                  child: Text(
                    'Ошибка загрузки мест',
                    style: GoogleFonts.philosopher(
                      color: AppColors.dangerColor,
                    ),
                  ),
                );
              }
              if (state is LocationsSuccesState) {
                final filtered = _filter(state.locations);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'Ничего не найдено',
                      style: GoogleFonts.philosopher(
                        color: AppColors.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.borderColor,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final location = filtered[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.softBlueColor,
                        child: Icon(
                          Icons.place,
                          color: AppColors.activeColor,
                        ),
                      ),
                      title: Text(
                        location.name,
                        style: GoogleFonts.philosopher(
                          fontSize: 16,
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: location.address != null
                          ? Text(
                              location.address!,
                              style: GoogleFonts.philosopher(
                                fontSize: 13,
                                color: AppColors.textSecondaryColor,
                              ),
                            )
                          : null,
                      onTap: () async {
                        await widget.mapController.moveCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: Point(
                                latitude: location.latitude,
                                longitude: location.longitude,
                              ),
                              zoom: 17.0,
                            ),
                          ),
                          animation: const MapAnimation(
                            type: MapAnimationType.smooth,
                          ),
                        );
                        widget.onPlaceSelected(location);
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
