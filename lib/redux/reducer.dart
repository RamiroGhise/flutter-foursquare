import 'package:venues/redux/actions.dart';
import 'package:venues/redux/app_state.dart';
import 'dart:developer' as devtools show log;

// Transform actions into states
AppState reducer(AppState oldState, action) {
  devtools.log("reducer action $action");
  if (action is LoadVenuesAction) {
    return const AppState(
      isLoading: true,
      venues: null,
      error: null,
    );
  } else if (action is SuccessfullyLoadVenuesAction) {
    return AppState(
      isLoading: false,
      venues: action.venues,
      error: null,
    );
  } else if (action is FailedLoadVenuesAction) {
    return AppState(
      isLoading: false,
      venues: oldState.venues,
      error: action.error,
    );
  } else {
    return oldState;
  }
}

