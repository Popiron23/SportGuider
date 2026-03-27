import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/data/models/coach_organization_model.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

class RostovOnDonPlaceSeed {
  final String id;
  final String name;
  final Sport sport;
  final String address;
  final String description;
  final double latitude;
  final double longitude;

  const RostovOnDonPlaceSeed({
    required this.id,
    required this.name,
    required this.sport,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  LocationEntity toLocationEntity() {
    return LocationEntity(
      id: id,
      latitude: latitude,
      longitude: longitude,
      name: name,
      sport: sport,
      address: address,
      description: description,
    );
  }

  CoachOrganizationModel toCoachOrganizationModel() {
    return CoachOrganizationModel(
      id: id,
      name: name,
      sport: sport,
      address: address,
      description: description,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

const rostovOnDonPlaceSeeds = <RostovOnDonPlaceSeed>[
  RostovOnDonPlaceSeed(
    id: 'rostov_arena_football',
    latitude: 47.2097,
    longitude: 39.7376,
    name: 'Ростов Арена',
    sport: Sport.football,
    address: 'Ростов-на-Дону, ул. Левобережная, 2Б',
    description:
        'Большая футбольная точка на левом берегу Дона. Подходит для матчей, открытых тренировок и встреч команд, которым нужны просторное поле, хорошая логистика и узнаваемая локация.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_lokomotiv_football',
    latitude: 47.2318,
    longitude: 39.6924,
    name: 'Стадион Локомотив',
    sport: Sport.football,
    address: 'Ростов-на-Дону, пр-т Стачки, 28',
    description:
        'Удобная городская площадка для футбольных занятий в более спокойном ритме. Хорошо подходит для детских и любительских групп, технической работы и вечерних тренировок рядом с центром.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_october_basketball',
    latitude: 47.2454,
    longitude: 39.7239,
    name: 'Октябрьский спортцентр',
    sport: Sport.basketball,
    address: 'Ростов-на-Дону, пр-т Нагибина, 14',
    description:
        'Точка для баскетбольных тренировок с акцентом на игровую практику и индивидуальную технику. Подойдёт для тех, кто хочет совмещать бросковую работу, координацию и спарринги.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_west_basketball',
    latitude: 47.2108,
    longitude: 39.6309,
    name: 'Западный баскет-холл',
    sport: Sport.basketball,
    address: 'Ростов-на-Дону, ул. Жмайлова, 4/10',
    description:
        'Комфортная баскетбольная локация для тренировок в западной части города. Здесь удобно проводить наборы в мини-группы, отрабатывать движение без мяча и собирать любительские игры.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_don_tennis',
    latitude: 47.2233,
    longitude: 39.7441,
    name: 'Теннисный клуб Дон',
    sport: Sport.tennis,
    address: 'Ростов-на-Дону, ул. Закруткина, 67В',
    description:
        'Точка для теннисных занятий в центре городского движения. Хороший вариант для персональных тренировок, постановки техники и работы на регулярность без долгих выездов за город.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_north_tennis',
    latitude: 47.2896,
    longitude: 39.7144,
    name: 'Северный теннис-парк',
    sport: Sport.tennis,
    address: 'Ростов-на-Дону, пр-т Космонавтов, 31А',
    description:
        'Удобная теннисная точка для северных районов Ростова. Подходит для взрослых и подростков, которым важны стабильный график, спокойная атмосфера и фокус на технику ударов.',
  ),
  RostovOnDonPlaceSeed(
    id: 'rostov_ice_palace_hockey',
    latitude: 47.2538,
    longitude: 39.7019,
    name: 'Ледовый дворец Северный',
    sport: Sport.hockey,
    address: 'Ростов-на-Дону, б-р Комарова, 28Г',
    description:
        'Хоккейная точка для тренировок на льду с упором на катание, игровые смены и дисциплину. Подходит для тех, кто ищет структурные занятия и понятный тренировочный ритм.',
  ),
  RostovOnDonPlaceSeed(
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
