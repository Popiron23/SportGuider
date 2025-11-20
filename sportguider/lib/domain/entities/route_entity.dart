class RouteEntity {
  final int id;
  final String? name; // название маршурта
  final Set<(double x, double y)>? coordinante; //координаты точек маршрута
  final double? length; //продолжительность маршрута
  final double? time; //время в пути

  RouteEntity({
    required this.id,
    this.name,
    this.coordinante,
    this.length,
    this.time,
  });
}
