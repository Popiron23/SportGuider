import 'package:equatable/equatable.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

abstract class LocationsEvent extends Equatable {
  const LocationsEvent();
  @override
  List<Object> get props => [];
}

class LocationsUpdateEvent extends LocationsEvent {
  final List<LocationEntity> locations;
  const LocationsUpdateEvent(this.locations);
  @override
  List<Object> get props => [locations];
}

class LocationsErrorEvent extends LocationsEvent {
  final String message;
  const LocationsErrorEvent(this.message);
  @override
  List<Object> get props => [message];
}
