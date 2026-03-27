import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sportguider/data/repositories/locations_repository.dart';
import 'locations_event.dart';
import 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository _repository;

  LocationsBloc({required LocationsRepository repository})
    : _repository = repository,
      super(LocationsLoading([])) {
    on<LocationsUpdateEvent>(_onUpdateEvent);
  }

  Future<void> _onUpdateEvent(
    LocationsUpdateEvent event,
    Emitter<LocationsState> emit,
  ) async {
    emit(LocationsLoading(state.sports));
    try {
      final locations = await _repository.getLocations(event.sports);
      emit(LocationsSuccesState(event.sports, locations));
    } catch (e) {
      emit(LocationsErrorState(state.sports, e.toString()));
    }
  }
}
