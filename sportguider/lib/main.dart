import 'package:flutter/material.dart';
import 'package:sportguider/presentation/app.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: String.fromEnvironment('MAPKIT_API_KEY'));

  runApp(const SportGuiderApp());
}
