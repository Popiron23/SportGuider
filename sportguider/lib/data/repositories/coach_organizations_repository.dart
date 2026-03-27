import 'package:firebase_database/firebase_database.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/data/models/coach_organization_model.dart';

class CoachOrganizationsRepository {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child(
    'places',
  );

  static const _presets = [
    (
      name: 'Arena North',
      sport: Sport.football,
      address: 'Москва, Ленинградский проспект, 36',
      description:
          'Современный зал для персональных тренировок, ОФП и работы с техникой движения.',
      latitude: 55.7964,
      longitude: 37.5340,
    ),
    (
      name: 'RunLab City',
      sport: Sport.football,
      address: 'Москва, Лужнецкая набережная, 24',
      description:
          'Локация для беговой подготовки, тестов выносливости и групповых сессий на открытом воздухе.',
      latitude: 55.7168,
      longitude: 37.5629,
    ),
    (
      name: 'Balance Studio',
      sport: Sport.tennis,
      address: 'Москва, улица Покровка, 17с1',
      description:
          'Студия с акцентом на мобильность, восстановление и аккуратную персональную работу.',
      latitude: 55.7613,
      longitude: 37.6415,
    ),
  ];

  Future<List<CoachOrganizationModel>> getAll() async {
    final snapshot = await _ref.get();

    if (snapshot.value == null) {
      return [];
    }

    final data = Map<Object?, Object?>.from(snapshot.value as Map);
    return data.values
        .map(
          (e) => CoachOrganizationModel.fromJson(
            Map<Object?, Object?>.from(e as Map),
          ),
        )
        .toList();
  }

  Future<CoachOrganizationModel> add(CoachOrganizationModel organization) async {
    final newRef = _ref.push();
    final withId = CoachOrganizationModel(
      id: newRef.key!,
      name: organization.name,
      sport: organization.sport,
      address: organization.address,
      description: organization.description,
      isCustom: organization.isCustom,
      latitude: organization.latitude,
      longitude: organization.longitude,
    );
    await newRef.set(withId.toJson());
    return withId;
  }

  Future<List<CoachOrganizationModel>> seedPresets() async {
    final results = <CoachOrganizationModel>[];
    for (final preset in _presets) {
      final saved = await add(
        CoachOrganizationModel(
          id: '',
          name: preset.name,
          sport: preset.sport,
          address: preset.address,
          description: preset.description,
          latitude: preset.latitude,
          longitude: preset.longitude,
        ),
      );
      results.add(saved);
    }
    return results;
  }
}
