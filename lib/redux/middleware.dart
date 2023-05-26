import 'package:redux/redux.dart';
import 'package:venues/redux/actions.dart';
import 'package:venues/redux/app_state.dart';
import 'package:venues/services/location/location_service.dart';

void loadVenuesMiddleware(
  Store<AppState> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadVenuesAction) {
    LocationService.foursquare().getVenues().then((venues) {
      // after the venues are successfully fetched, notify the reducer
      store.dispatch(SuccessfullyLoadVenuesAction(venues: venues));
    }).catchError((e) {
      store.dispatch(FailedLoadVenuesAction(error: e));
    });
  }
  // send the action to the next middleware and/or to the reducer
  next(action);
}

