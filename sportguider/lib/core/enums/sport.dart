import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Sport { basketball, football, tennis, hockey }

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
    }
  }
}
