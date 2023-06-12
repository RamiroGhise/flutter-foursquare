import 'package:bloc/bloc.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/app_state.dart';
import 'package:venues/services/location/location_service.dart';
import 'dart:developer' as devtools show log;

class VenuesBloc extends Bloc<LoadAction, AppState> {
  VenuesBloc() : super(const AppState.empty()) {
    on<LoadVenuesAction>((event, emit) async {
      devtools.log("VenuesBloc, LoadVenuesAction");
      emit(const AppState(
        isLoading: true,
        venues: null,
        error: null,
      ));
      try {
        final venues = await LocationService.foursquare().getVenues(
          searchQuery: event.searchText,
          searchRadius: event.searchRadius,
        );
        emit(AppState(
          isLoading: false,
          venues: venues,
          error: null,
        ));
      } on Exception catch (e) {
        emit(AppState(
          isLoading: false,
          venues: state.venues,
          error: e,
        ));
      }
    });
  }
}
