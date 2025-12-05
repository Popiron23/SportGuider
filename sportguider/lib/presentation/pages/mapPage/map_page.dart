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
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  final List<LocationEntity> locations;
  const MapPage({super.key, required this.locations});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final mapKey = GlobalKey();
  late final List<PlacemarkMapObject> mapObjects;
  late final YandexMapController mapController;

  Future<bool> get locationPermissionNotGranted async =>
      !(await Permission.location.request().isGranted);

  void _showMessage(Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

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
                  'assets/images/png/placemark_icon.png',
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
            YandexMap(
              key: mapKey,
              mapObjects: mapObjects,
              onMapCreated: (controller) {
                mapController = controller;
              },
              onUserLocationAdded: (UserLocationView view) async {
                return view.copyWith(
                  pin: view.pin.copyWith(
                    icon: PlacemarkIcon.single(
                      PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage(
                          'assets/images/png/user.png',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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
            Positioned(
              right: 10,
              bottom: 5,
              child: GeolocationButton(
                onPressed: () async {
                  if (await locationPermissionNotGranted) {
                    _showMessage(
                      const Text('Location permission was NOT granted'),
                    );
                    return;
                  }

                  final mediaQuery = MediaQuery.of(context);
                  final height =
                      mapKey.currentContext!.size!.height *
                      mediaQuery.devicePixelRatio;
                  final width =
                      mapKey.currentContext!.size!.width *
                      mediaQuery.devicePixelRatio;

                  await mapController.toggleUserLayer(
                    visible: true,
                    autoZoomEnabled: false,
                    headingEnabled: false,
                    anchor: UserLocationAnchor(
                      course: Offset(0.5 * width, 0.5 * height),
                      normal: Offset(0.5 * width, 0.5 * height),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              right: 10,
              top: constraints.maxHeight / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomPlusButton(
                    onPressed: () =>
                        mapController.moveCamera(CameraUpdate.zoomIn()),
                  ),
                  const SizedBox(height: 10),
                  ZoomMinusButton(
                    onPressed: () =>
                        mapController.moveCamera(CameraUpdate.zoomOut()),
                  ),
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
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.4,
          widthFactor: 1.0,
          child: ModalBodyView(location: location),
        ),
      );
}
