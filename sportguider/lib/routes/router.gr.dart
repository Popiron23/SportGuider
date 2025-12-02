// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:collection/collection.dart' as _i8;
import 'package:flutter/material.dart' as _i6;
import 'package:sportguider/domain/entities/location_entity.dart' as _i7;
import 'package:sportguider/presentation/pages/friendPage/friend_page.dart'
    as _i1;
import 'package:sportguider/presentation/pages/mapPage/map_page.dart' as _i3;
import 'package:sportguider/presentation/pages/regPage/reg_page.dart' as _i4;
import 'package:sportguider/presentation/widgets/home_page.dart' as _i2;

/// generated route for
/// [_i1.FriendPage]
class FriendRoute extends _i5.PageRouteInfo<void> {
  const FriendRoute({List<_i5.PageRouteInfo>? children})
    : super(FriendRoute.name, initialChildren: children);

  static const String name = 'FriendRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.FriendPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.MapPage]
class MapRoute extends _i5.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i6.Key? key,
    required List<_i7.LocationEntity> locations,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         MapRoute.name,
         args: MapRouteArgs(key: key, locations: locations),
         initialChildren: children,
       );

  static const String name = 'MapRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapRouteArgs>();
      return _i3.MapPage(key: args.key, locations: args.locations);
    },
  );
}

class MapRouteArgs {
  const MapRouteArgs({this.key, required this.locations});

  final _i6.Key? key;

  final List<_i7.LocationEntity> locations;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, locations: $locations}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapRouteArgs) return false;
    return key == other.key &&
        const _i8.ListEquality<_i7.LocationEntity>().equals(
          locations,
          other.locations,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i8.ListEquality<_i7.LocationEntity>().hash(locations);
}

/// generated route for
/// [_i4.RegPage]
class RegRoute extends _i5.PageRouteInfo<void> {
  const RegRoute({List<_i5.PageRouteInfo>? children})
    : super(RegRoute.name, initialChildren: children);

  static const String name = 'RegRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegPage();
    },
  );
}
