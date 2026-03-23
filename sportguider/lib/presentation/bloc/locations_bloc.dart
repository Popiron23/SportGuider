import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sportguider/data/repositories/locations_repository.dart';
import 'locations_event.dart';
import 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository _repository;
  StreamSubscription? _locationsSubscription;

  LocationsBloc({required LocationsRepository repository})
    : _repository = repository,
      super(LocationsLoading()) {
    on<LocationsUpdateEvent>(_onUpdateEvent);
    on<LocationsErrorEvent>(_onErrorEvent);
    _locationsSubscription = _repository.getLocationsStream().listen(
      (locations) {
        add(LocationsUpdateEvent(locations));
      },
      onError: (error) {
        add(LocationsErrorEvent(error.toString()));
      },
    );
  }

  Future<void> _onUpdateEvent(
    LocationsUpdateEvent event,
    Emitter<LocationsState> emit,
  ) async {
    emit(LocationsSuccesState(event.locations));
  }

  Future<void> _onErrorEvent(
    LocationsErrorEvent event,
    Emitter<LocationsState> emit,
  ) async {
    emit(LocationsErrorState(event.message));
  }

  @override
  Future<void> close() async {
    await _locationsSubscription?.cancel();
    return super.close();
  }
}
