import 'package:equatable/equatable.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as yandex;

class LocationEntity extends Equatable {
  final String id; //id места
  final double latitude, longitude; //широта и долгота
  final String name; //название места
  final Sport sport;
  final String? address; //адрес
  final String? description; //описание
  final List<CoachEntity>? coaches;

  const LocationEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.sport,
    this.address,
    this.description,
    this.coaches,
  });
  static LocationEntity? tryFromFirebase(Map<Object?, Object?> data) {
    final lat = (data['latitude'] as num?)?.toDouble();
    final lon = (data['longitude'] as num?)?.toDouble();
    if (lat == null || lon == null) return null;

    final rawId = data['id'];
    final id = rawId is int
        ? rawId.toString()
        : ((rawId as String?) ?? data.hashCode.toString());

    final name =
        (data['name'] as String?) ?? (data['title'] as String?) ?? '';

    final sportStr = data['sport'] as String?;
    Sport? sport;
    if (sportStr != null) {
      try {
        sport = Sport.values.firstWhere((e) => e.name == sportStr);
      } catch (_) {
        sport = null;
      }
    }
    if (sport == null) return null;

    return LocationEntity(
      id: id,
      latitude: lat,
      longitude: lon,
      name: name,
      sport: sport,
      address: data['address'] as String?,
      description: data['description'] as String?,
    );
  }

  factory LocationEntity.fromFirebase(Map<Object?, Object?> data) {
    return LocationEntity.tryFromFirebase(data)!;
  }

  // Конвертация в Yandex Point
  yandex.Point toPoint() {
    return yandex.Point(latitude: latitude, longitude: longitude);
  }

  @override
  List<Object?> get props => [id, latitude, longitude, name, description];
}
