import 'package:bloc/bloc.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/app_state.dart';
import 'dart:developer' as devtools show log;
import 'package:venues/crud/venue_database_service.dart';

class VenuesBloc extends Bloc<LoadAction, AppState> {
  VenuesBloc() : super(AppState.empty()) {
    // fetch venues from the internet
    on<LoadVenuesAction>((event, emit) async {
      devtools.log("VenuesBloc, triggered LoadVenuesAction");
      emit(AppState(
        isLoading: true,
        venues: null,
        bookmarks: state.bookmarks,
        error: null,
      ));
      try {
        final venues = await event.loader(
          searchQuery: event.searchText,
          searchRadius: event.searchRadius,
        );
        emit(AppState(
          isLoading: false,
          venues: venues,
          bookmarks: state.bookmarks,
          error: null,
        ));
      } on Exception catch (e) {
        emit(AppState(
          isLoading: false,
          venues: state.venues,
          bookmarks: state.bookmarks,
          error: e,
        ));
      }
    });

    // generates a state with the bookmarks loaded
    on<InitializeBookmarksAction>((event, emit) async {
      devtools.log('VenuesBloc, triggered InitializeBookmarksAction');
      emit(AppState(
        isLoading: true,
        venues: state.venues,
        bookmarks: state.bookmarks,
        error: null,
      ));
      try {
        final bookmarks = await VenuesDatabaseService().getAllVenues();
        emit(AppState(
          isLoading: false,
          venues: state.venues,
          bookmarks: bookmarks.toList(),
          error: null,
        ));
      } catch (_) {}
    });

    // the user adds a venue to bookmarks or removes a venue from bookmarks
    on<AddOrRemoveVenueBookmarkAction>((event, emit) async {
      devtools.log("VenuesBloc, triggered AddOrRemoveVenueBookmarkAction");

      bool isVenueBookmarked = false;
      for (var bookmark in state.bookmarks) {
        if (bookmark.venueId == event.venueId) {
          isVenueBookmarked = true;
          break;
        }
      }

      if (isVenueBookmarked) {
        // remove from bookmarks
        await VenuesDatabaseService().deleteVenue(venueId: event.venueId);
      } else {
        // add to bookmarks
        await VenuesDatabaseService().createVenue(venueId: event.venueId);
      }
      final bookmarks = await VenuesDatabaseService().getAllVenues();
      emit(AppState(
        isLoading: false,
        venues: state.venues,
        bookmarks: bookmarks.toList(),
        error: null,
      ));
    });
  }
}
