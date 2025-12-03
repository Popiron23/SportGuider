import 'package:flutter/material.dart' hide ImageProvider;
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:yandex_maps_mapkit_lite/image.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/profile_button.dart';

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
          ProfileButton(),
          YandexMap(onMapCreated: _onMapCreated),
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
