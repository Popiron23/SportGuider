// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:collection/collection.dart' as _i13;
import 'package:flutter/material.dart' as _i11;
import 'package:sportguider/domain/entities/location_entity.dart' as _i12;
import 'package:sportguider/presentation/pages/authPage/auth_page.dart' as _i1;
import 'package:sportguider/presentation/pages/coachPage/coach_page.dart'
    as _i2;
import 'package:sportguider/presentation/pages/coachProfilePage/coachProfile_page.dart'
    as _i3;
import 'package:sportguider/presentation/pages/friendPage/friend_page.dart'
    as _i4;
import 'package:sportguider/presentation/pages/mapPage/map_page.dart' as _i6;
import 'package:sportguider/presentation/pages/regPage/reg_page.dart' as _i7;
import 'package:sportguider/presentation/pages/root_page.dart' as _i8;
import 'package:sportguider/presentation/pages/userProfilePage/userProfile_page.dart'
    as _i9;
import 'package:sportguider/presentation/widgets/home_page.dart' as _i5;

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i10.PageRouteInfo<void> {
  const AuthRoute({List<_i10.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthPage();
    },
  );
}

/// generated route for
/// [_i2.CoachPage]
class CoachRoute extends _i10.PageRouteInfo<void> {
  const CoachRoute({List<_i10.PageRouteInfo>? children})
    : super(CoachRoute.name, initialChildren: children);

  static const String name = 'CoachRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.CoachPage();
    },
  );
}

/// generated route for
/// [_i3.CoachProfilePage]
class CoachProfileRoute extends _i10.PageRouteInfo<void> {
  const CoachProfileRoute({List<_i10.PageRouteInfo>? children})
    : super(CoachProfileRoute.name, initialChildren: children);

  static const String name = 'CoachProfileRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.CoachProfilePage();
    },
  );
}

/// generated route for
/// [_i4.FriendPage]
class FriendRoute extends _i10.PageRouteInfo<void> {
  const FriendRoute({List<_i10.PageRouteInfo>? children})
    : super(FriendRoute.name, initialChildren: children);

  static const String name = 'FriendRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.FriendPage();
    },
  );
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute({List<_i10.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomePage();
    },
  );
}

/// generated route for
/// [_i6.MapPage]
class MapRoute extends _i10.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i11.Key? key,
    required List<_i12.LocationEntity> locations,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         MapRoute.name,
         args: MapRouteArgs(key: key, locations: locations),
         initialChildren: children,
       );

  static const String name = 'MapRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapRouteArgs>();
      return _i6.MapPage(key: args.key, locations: args.locations);
    },
  );
}

class MapRouteArgs {
  const MapRouteArgs({this.key, required this.locations});

  final _i11.Key? key;

  final List<_i12.LocationEntity> locations;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, locations: $locations}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapRouteArgs) return false;
    return key == other.key &&
        const _i13.ListEquality<_i12.LocationEntity>().equals(
          locations,
          other.locations,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i13.ListEquality<_i12.LocationEntity>().hash(locations);
}

/// generated route for
/// [_i7.RegPage]
class RegRoute extends _i10.PageRouteInfo<void> {
  const RegRoute({List<_i10.PageRouteInfo>? children})
    : super(RegRoute.name, initialChildren: children);

  static const String name = 'RegRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegPage();
    },
  );
}

/// generated route for
/// [_i8.RootPage]
class RootRoute extends _i10.PageRouteInfo<void> {
  const RootRoute({List<_i10.PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.RootPage();
    },
  );
}

/// generated route for
/// [_i9.UserProfilePage]
class UserProfileRoute extends _i10.PageRouteInfo<void> {
  const UserProfileRoute({List<_i10.PageRouteInfo>? children})
    : super(UserProfileRoute.name, initialChildren: children);

  static const String name = 'UserProfileRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.UserProfilePage();
    },
  );
}
