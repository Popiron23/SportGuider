import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/filter_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/geolocation_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/modal_body_view.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/profile_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/search_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/zoom_minus_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/zoom_plus_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  final List<LocationEntity> locations;
  const MapPage({super.key, required this.locations});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final List<PlacemarkMapObject> mapObjects;

  @override
  void initState() {
    super.initState();
    mapObjects = widget.locations
        .map(
          (e) => PlacemarkMapObject(
            mapId: MapObjectId(e.id.toString()),
            point: Point(latitude: e.latitude, longitude: e.longitude),
            onTap: (self, point) => _onPlacemarkTap(context, e),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/placemark_icon.png',
                ),
                scale: 3.0,
              ),
            ),
            opacity: 1.0,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            YandexMap(mapObjects: mapObjects),
            Positioned(left: 15, top: 5, child: ProfileButton()),
            Positioned(
              right: 10,
              top: 5,
              child: Row(
                children: [
                  FilterButton(),
                  const SizedBox(width: 10),
                  SearchButton(),
                ],
              ),
            ),
            Positioned(right: 10, bottom: 5, child: GeolocationButton()),

            Positioned(
              right: 10,
              top: constraints.maxHeight / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomPlusButton(),
                  const SizedBox(height: 10),
                  ZoomMinusButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPlacemarkTap(BuildContext context, LocationEntity location) =>
      showModalBottomSheet(
        context: context,
        builder: (context) => ModalBodyView(location: location),
      );
}
