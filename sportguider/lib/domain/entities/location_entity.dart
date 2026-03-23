import 'package:equatable/equatable.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as yandex;

class LocationEntity extends Equatable {
  final String id; //id места
  final double latitude, longitude; //широта и долгота
  final String name; //название места
  final String? address; //адрес
  final String? description; //описание
  final List<CoachEntity>? coaches;

  const LocationEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    this.address,
    this.description,
    this.coaches,
  });
  factory LocationEntity.fromFirebase(Map<Object?, Object?> data) {
    return LocationEntity(
      id: (data['id'] as int).toString(),
      latitude: (data['latitude'] as double),
      longitude: (data['longitude'] as double),
      name: (data['name'] as String),
    );
  }

  // Конвертация в Yandex Point
  yandex.Point toPoint() {
    return yandex.Point(latitude: latitude, longitude: longitude);
  }

  @override
  List<Object?> get props => [id, latitude, longitude, name, description];
}
