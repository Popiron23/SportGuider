import 'package:firebase_database/firebase_database.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/data/fixtures/rostov_on_don_places.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

class LocationsRepository {
  final DatabaseReference _locationsRef = FirebaseDatabase.instance.ref().child(
    'places',
  );

  Future<List<LocationEntity>> getLocations(List<Sport> sports) async {
    final snapshot = await _locationsRef.get();

    final remoteLocations = <LocationEntity>[];
    if (snapshot.value != null) {
      final locationsData = Map<String, dynamic>.from(snapshot.value as Map);
      remoteLocations.addAll(
        locationsData.values
            .map((e) => LocationEntity.tryFromFirebase(
                  Map<Object?, Object?>.from(e as Map),
                ))
            .whereType<LocationEntity>(),
      );
    }

    final localLocations = rostovOnDonPlaceSeeds
        .map((seed) => seed.toLocationEntity())
        .toList();

    final mergedLocations = <String, LocationEntity>{
      for (final location in remoteLocations) location.id: location,
      for (final location in localLocations) location.id: location,
    };

    return mergedLocations.values
        .where((e) => sports.contains(e.sport))
        .toList();
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
