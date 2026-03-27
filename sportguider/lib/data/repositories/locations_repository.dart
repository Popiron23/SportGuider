import 'package:firebase_database/firebase_database.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

class LocationsRepository {
  final DatabaseReference _locationsRef = FirebaseDatabase.instance.ref().child(
    'places',
  );

  static const List<LocationEntity> _rostovOnDonLocations = [
    LocationEntity(
      id: 'rostov_arena_football',
      latitude: 47.2097,
      longitude: 39.7376,
      name: 'Ростов Арена',
      sport: Sport.football,
      address: 'Ростов-на-Дону, ул. Левобережная, 2Б',
      description:
          'Большая футбольная точка на левом берегу Дона. Подходит для матчей, открытых тренировок и встреч команд, которым нужны просторное поле, хорошая логистика и узнаваемая локация.',
    ),
    LocationEntity(
      id: 'rostov_lokomotiv_football',
      latitude: 47.2318,
      longitude: 39.6924,
      name: 'Стадион Локомотив',
      sport: Sport.football,
      address: 'Ростов-на-Дону, пр-т Стачки, 28',
      description:
          'Удобная городская площадка для футбольных занятий в более спокойном ритме. Хорошо подходит для детских и любительских групп, технической работы и вечерних тренировок рядом с центром.',
    ),
    LocationEntity(
      id: 'rostov_october_basketball',
      latitude: 47.2454,
      longitude: 39.7239,
      name: 'Октябрьский спортцентр',
      sport: Sport.basketball,
      address: 'Ростов-на-Дону, пр-т Нагибина, 14',
      description:
          'Точка для баскетбольных тренировок с акцентом на игровую практику и индивидуальную технику. Подойдёт для тех, кто хочет совмещать бросковую работу, координацию и спарринги.',
    ),
    LocationEntity(
      id: 'rostov_west_basketball',
      latitude: 47.2108,
      longitude: 39.6309,
      name: 'Западный баскет-холл',
      sport: Sport.basketball,
      address: 'Ростов-на-Дону, ул. Жмайлова, 4/10',
      description:
          'Комфортная баскетбольная локация для тренировок в западной части города. Здесь удобно проводить наборы в мини-группы, отрабатывать движение без мяча и собирать любительские игры.',
    ),
    LocationEntity(
      id: 'rostov_don_tennis',
      latitude: 47.2233,
      longitude: 39.7441,
      name: 'Теннисный клуб Дон',
      sport: Sport.tennis,
      address: 'Ростов-на-Дону, ул. Закруткина, 67В',
      description:
          'Точка для теннисных занятий в центре городского движения. Хороший вариант для персональных тренировок, постановки техники и работы на регулярность без долгих выездов за город.',
    ),
    LocationEntity(
      id: 'rostov_north_tennis',
      latitude: 47.2896,
      longitude: 39.7144,
      name: 'Северный теннис-парк',
      sport: Sport.tennis,
      address: 'Ростов-на-Дону, пр-т Космонавтов, 31А',
      description:
          'Удобная теннисная точка для северных районов Ростова. Подходит для взрослых и подростков, которым важны стабильный график, спокойная атмосфера и фокус на технику ударов.',
    ),
    LocationEntity(
      id: 'rostov_ice_palace_hockey',
      latitude: 47.2538,
      longitude: 39.7019,
      name: 'Ледовый дворец Северный',
      sport: Sport.hockey,
      address: 'Ростов-на-Дону, б-р Комарова, 28Г',
      description:
          'Хоккейная точка для тренировок на льду с упором на катание, игровые смены и дисциплину. Подходит для тех, кто ищет структурные занятия и понятный тренировочный ритм.',
    ),
    LocationEntity(
      id: 'rostov_leftbank_hockey',
      latitude: 47.2119,
      longitude: 39.7542,
      name: 'Левобережная ледовая арена',
      sport: Sport.hockey,
      address: 'Ростов-на-Дону, Левобережный парк',
      description:
          'Современная локация для хоккейных тренировок и просмотровых сборов. Удобна для игроков, которым важно сочетание льда, восстановительной инфраструктуры и понятной навигации по району.',
    ),
  ];

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

    final mergedLocations = <String, LocationEntity>{
      for (final location in remoteLocations) location.id: location,
      for (final location in _rostovOnDonLocations) location.id: location,
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
