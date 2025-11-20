class LocationEntity {
  final int id; //id места
  final double? latitude, longitude; //широта и долгота
  final String? name; //название места
  final String? address; //адрес
  final String? description; //описание

  LocationEntity({
    required this.id,
    this.latitude,
    this.longitude,
    this.name,
    this.address,
    this.description,
  });
}
