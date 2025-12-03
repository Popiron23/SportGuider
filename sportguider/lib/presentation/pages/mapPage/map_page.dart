import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/profile_button.dart';
import 'package:yandex_maps_mapkit/image.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  final List<LocationEntity> locations;
  const MapPage({super.key, required this.locations});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    mapkit.onStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
        textDirection: TextDirection.ltr,
        children: [
          YandexMap(onMapCreated: _onMapCreated),
          Positioned(left: 10, top: 10, child: ProfileButton()),
        ],
      ),
    );
  }

  void _onMapCreated(MapWindow mapWindow) {
    for (final location in widget.locations) {
      final (lat, lon) = (location.latitude, location.longitude);

      mapWindow.map.mapObjects.addPlacemark()
        ..geometry = Point(latitude: lat, longitude: lon)
        ..setIcon(
          ImageProvider.fromImageProvider(
            AssetImage("assets/images/placemark_icon.png"),
          ),
        );
    }
  }

  @override
  void dispose() {
    mapkit.onStop();
    super.dispose();
  }
}
