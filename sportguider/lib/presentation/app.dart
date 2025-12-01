import 'package:flutter/material.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/pages/map_page.dart';

class SportGuiderApp extends StatefulWidget {
  const SportGuiderApp({super.key});

  @override
  State<SportGuiderApp> createState() => _SportGuiderAppState();
}

class _SportGuiderAppState extends State<SportGuiderApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: MapPage(
      locations: [
        LocationEntity(id: 1, latitude: 55.751225, longitude: 37.62954),
        LocationEntity(id: 2, latitude: 55.75154, longitude: 37.62932),
        LocationEntity(id: 3, latitude: 55.89321, longitude: 37.62678),
      ],
    ),
  );
}
