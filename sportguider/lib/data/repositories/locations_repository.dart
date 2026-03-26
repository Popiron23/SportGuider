import 'package:firebase_database/firebase_database.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

class LocationsRepository {
  final DatabaseReference _locationsRef = FirebaseDatabase.instance.ref().child(
    'places',
  );

  Future<List<LocationEntity>> getLocations(List<Sport> sports) async {
    final snapshot = await _locationsRef.get();

    if (snapshot.value == null) {
      return <LocationEntity>[];
    }

    final locationsData = Map<String, dynamic>.from(snapshot.value as Map);

    final List<LocationEntity> locations = locationsData.values
        .map((e) => LocationEntity.tryFromFirebase(
              Map<Object?, Object?>.from(e as Map),
            ))
        .whereType<LocationEntity>()
        .where((e) => sports.contains(e.sport))
        .toList();
    return locations;
  }

  Future<void> addlocation(LocationEntity location) async {
    await _locationsRef.child(location.id).set({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'title': location.name,
      'description': location.description,
    });
  }

  Future<void> deletelocation(String locationId) async {
    await _locationsRef.child(locationId).remove();
  }
}
