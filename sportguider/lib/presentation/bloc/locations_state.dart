import 'package:equatable/equatable.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

sealed class LocationsState extends Equatable {
  final List<Sport> sports;
  const LocationsState(this.sports);
  @override
  List<Object> get props => [sports];
}

class LocationsLoading extends LocationsState {
  const LocationsLoading(super.sports);
}

class LocationsSuccesState extends LocationsState {
  final List<LocationEntity> locations;
  const LocationsSuccesState(super.sports, this.locations);
  @override
  List<Object> get props => [locations, sports];
}

class LocationsErrorState extends LocationsState {
  final String message;
  const LocationsErrorState(super.sports, this.message);
  @override
  List<Object> get props => [message];
}
