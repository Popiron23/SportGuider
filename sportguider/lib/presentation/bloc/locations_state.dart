import 'package:equatable/equatable.dart';
import 'package:sportguider/domain/entities/location_entity.dart';

sealed class LocationsState extends Equatable {
  const LocationsState();
  @override
  List<Object> get props => [];
}

class LocationsLoading extends LocationsState {}

class LocationsSuccesState extends LocationsState {
  final List<LocationEntity> locations;
  const LocationsSuccesState(this.locations);
  @override
  List<Object> get props => [locations];
}

class LocationsErrorState extends LocationsState {
  final String message;
  const LocationsErrorState(this.message);
  @override
  List<Object> get props => [message];
}
