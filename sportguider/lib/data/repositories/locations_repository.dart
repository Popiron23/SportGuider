import 'package:firebase_database/firebase_database.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

class LocationsRepository {
  final DatabaseReference _locationsRef = FirebaseDatabase.instance.ref().child(
    'places',
  );

  Stream<List<LocationEntity>> getLocationsStream() {
    return _locationsRef.onValue.map((event) {
      final snapshot = event.snapshot;

      if (snapshot.value == null) {
        return <LocationEntity>[];
      }

      final locationsData = Map<String, dynamic>.from(snapshot.value as Map);
      final List<LocationEntity> locations = [];

      locationsData.forEach((key, value) {
        try {
          final location = LocationEntity.fromFirebase(value);
          locations.add(location);
        } catch (e) {
          print('Error parsing location $key: $e');
        }
      });

      return locations;
    });
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
