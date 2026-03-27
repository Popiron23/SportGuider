import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Sport { basketball, football, tennis, hockey, box, athletics, volleyball, swimming, cycling, skiing, martialArts }

extension SportExtension on Sport {
  String get ru {
    switch (this) {
      case Sport.basketball:
        return 'Баскетбол';
      case Sport.football:
        return 'Футбол';
      case Sport.tennis:
        return 'Теннис';
      case Sport.hockey:
        return 'Хоккей';
      case Sport.box:
        return 'Бокс';
      case Sport.athletics:
        return 'Лёгкая атлетика';
      case Sport.volleyball:
        return 'Волейбол';
      case Sport.swimming:
        return 'Плавание';
      case Sport.cycling:
        return 'Велоспорт';
      case Sport.skiing:
        return 'Лыжный спорт';
      case Sport.martialArts:
        return 'Единоборства';
    }
  }

  IconData get icon {
    switch (this) {
      case Sport.basketball:
        return Icons.sports_basketball;
      case Sport.football:
        return Icons.sports_soccer;
      case Sport.tennis:
        return Icons.sports_tennis;
      case Sport.hockey:
        return Icons.sports_hockey;
      case Sport.box:
        return Icons.sports_mma;
      case Sport.athletics:
        return Icons.directions_run;
      case Sport.volleyball:
        return Icons.sports_volleyball;
      case Sport.swimming:
        return Icons.pool;
      case Sport.cycling:
        return Icons.directions_bike;
      case Sport.skiing:
        return Icons.downhill_skiing;
      case Sport.martialArts:
        return Icons.sports_kabaddi;
    }
  }
}
