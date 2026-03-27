import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportguider/data/repositories/locations_repository.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/bloc/locations_bloc.dart';
import 'package:sportguider/presentation/bloc/locations_event.dart';
import 'package:sportguider/presentation/bloc/locations_state.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/filter_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/geolocation_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/modal_body_view.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/profile_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/search_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/search_panel.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/zoom_minus_button.dart';
import 'package:sportguider/presentation/pages/mapPage/widgets/zoom_plus_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final mapKey = GlobalKey();

  late YandexMapController mapController;
  final MapObjectId largeMapObjectId = const MapObjectId(
    'large_clusterized_placemark_collection',
  );
  Future<bool> get locationPermissionNotGranted async =>
      !(await Permission.location.request().isGranted);

  void _showMessage(Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColors.activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    const radius = 60.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: const TextStyle(color: Colors.black, fontSize: 50),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  BoundingBox? _getBoundingBoxForPoints(List<PlacemarkMapObject> points) {
    if (points.isEmpty) return null;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLon = double.infinity;
    double maxLon = -double.infinity;

    for (final placemark in points) {
      final point = placemark.point;
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    // Добавляем небольшой отступ (padding) по краям, чтобы точки не были впритык к краю экрана
    final latPadding = (maxLat - minLat) * 0.15;
    final lonPadding = (maxLon - minLon) * 0.15;

    return BoundingBox(
      southWest: Point(
        latitude: minLat - latPadding,
        longitude: minLon - lonPadding,
      ),
      northEast: Point(
        latitude: maxLat + latPadding,
        longitude: maxLon + lonPadding,
      ),
    );
  }

  List<MapObject> _updateLocations(List<LocationEntity> locations) {
    List<MapObject> mapObjects = [];
    final largeMapObject = ClusterizedPlacemarkCollection(
      mapId: largeMapObjectId,
      radius: 110,
      minZoom: 15,
      onClusterAdded:
          (ClusterizedPlacemarkCollection self, Cluster cluster) async {
            return cluster.copyWith(
              appearance: cluster.appearance.copyWith(
                opacity: 0.75,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromBytes(
                      await _buildClusterAppearance(cluster),
                    ),
                    scale: 1,
                  ),
                ),
              ),
            );
          },
      onClusterTap: (ClusterizedPlacemarkCollection self, Cluster cluster) async {
        final pointsInCluster = cluster.placemarks;

        if (pointsInCluster.isEmpty) {
          return;
        }

        // 2. Если в кластере всего одна точка, просто приближаем к ней
        if (pointsInCluster.length == 1) {
          await mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: pointsInCluster.first.point,
                zoom: 17.0, // Комфортный зум для одной точки
              ),
            ),
            animation: MapAnimation(type: MapAnimationType.smooth),
          );
          return;
        }

        // 3. Для нескольких точек вычисляем BoundingBox и устанавливаем камеру
        final boundingBox = _getBoundingBoxForPoints(pointsInCluster);

        if (boundingBox != null) {
          await mapController.moveCamera(
            CameraUpdate.newGeometry(Geometry.fromBoundingBox(boundingBox)),
            animation: MapAnimation(type: MapAnimationType.smooth),
          );
        }
      },
      placemarks: locations
          .map(
            (e) => PlacemarkMapObject(
              mapId: MapObjectId(e.id.toString()),
              point: Point(latitude: e.latitude, longitude: e.longitude),
              onTap: (self, point) => _onPlacemarkTap(context, e),
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    'assets/images/png/mark.png',
                  ),
                  scale: 0.1,
                ),
              ),
              opacity: 1.0,
            ),
          )
          .toList(),
    );
    mapObjects.add(largeMapObject);
    return mapObjects;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocationsBloc(repository: LocationsRepository())
            ..add(LocationsUpdateEvent([])),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              BlocConsumer<LocationsBloc, LocationsState>(
                listener: (context, state) {
                  if (state is LocationsSuccesState) {
                    _updateLocations(state.locations);
                  }
                  if (state is LocationsErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  switch (state) {
                    case LocationsLoading():
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.activeColor,
                        ),
                      );
                    case LocationsSuccesState():
                      return YandexMap(
                        key: mapKey,
                        mapObjects: _updateLocations(state.locations),
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
                      );
                    case LocationsErrorState():
                      return SizedBox.shrink();
                  }
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
                    SearchButton(onPressed: () => _openSearchPanel(context)),
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
      ),
    );
  }

  void _openSearchPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<LocationsBloc>(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SearchPanel(
            mapController: mapController,
            onPlaceSelected: (location) {
              Navigator.pop(sheetContext);
              _onPlacemarkTap(context, location);
            },
          ),
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
