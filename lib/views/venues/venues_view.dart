import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/app_state.dart';
import 'package:venues/bloc/venues_bloc.dart';
import 'package:venues/constants/routes.dart';
import 'package:venues/services/location/location_exceptions.dart';
import 'package:venues/services/location/location_service.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/utilities/show_error_dialog.dart';
import 'package:venues/views/venues/venues_list_view.dart';

class VenuesView extends StatefulWidget {
  const VenuesView({Key? key}) : super(key: key);

  @override
  State<VenuesView> createState() => _VenuesViewState();
}

class _VenuesViewState extends State<VenuesView> {
  List<Venue> venuesList = [];
  late final TextEditingController _search;
  late final TextEditingController _radius;

  @override
  void initState() {
    _search = TextEditingController();
    _radius = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    _radius.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(favoriteVenuesRoute);
            },
            icon: const Icon(Icons.bookmark_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Please use the below text fields to search for nearby venues. Optionally, you can adjust the search distance (in meters) by using the 'Search radius' field."),
            TextField(
              controller: _search,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Search here'),
            ),
            TextField(
              controller: _radius,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Search radius (in meters)'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
              child: ElevatedButton(
                onPressed: () async {
                  final searchQuery = _search.text;
                  final radius = _radius.text;
                  context.read<VenuesBloc>().add(LoadVenuesAction(
                        searchText: searchQuery,
                        searchRadius: radius,
                        loader: LocationService.foursquare().getVenues,
                      ));
                },
                child: const Text(
                  'Find venues',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            BlocBuilder<VenuesBloc, AppState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
            BlocBuilder<VenuesBloc, AppState>(
              builder: (context, state) {
                final venues = state.venues;

                if (venues == null) {
                  return Container();
                }
                return Expanded(
                  child: VenuesListView(
                    venues: venues,
                    onTap: (venue) {
                      Navigator.of(context).pushNamed(
                        venueDetailsRoute,
                        arguments: venue,
                      );
                    },
                  ),
                );
              },
            ),
            BlocListener<VenuesBloc, AppState>(
              listenWhen: (previous, current) {
                return current.error != null;
              },
              listener: (context, state) {
                final error = state.error;
                if (error != null) {
                  if (error is BadRequestLocationException) {
                    showErrorDialog(context, error.text);
                  } else if (error is UnauthorizedLocationException) {
                    showErrorDialog(context, error.text);
                  } else if (error is SocketException) {
                    showErrorDialog(context, error.message);
                  } else if (error is NoVenuesFoundLocationException) {
                    showErrorDialog(
                      context,
                      'No venues found. Please consider increasing the search radius',
                    );
                  } else {
                    showErrorDialog(context, error.toString());
                  }
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

// /// Change notifier holds on to the state of the search fields.
// class SearchData extends ChangeNotifier {
//   String _venueName = '';
//   double _radius = 0.0;
//
//   double get radius => _radius;
//
//   String get venueName => _venueName;
//
//   set radius(double newValue) {
//     if (newValue != _radius) {
//       _radius = newValue;
//       notifyListeners();
//     }
//   }
// }
//
// final searchData = SearchData();

// class SearchInheritedNotifier extends InheritedNotifier<SearchData> {
//   final SearchData searchData;
//
//   const SearchInheritedNotifier({
//     Key? key,
//     required this.searchData,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: searchData,
//           child: child,
//         );
//
//   static double of(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<SearchInheritedNotifier>()
//         ?.notifier
//         ?.value ??
//         0;
//   }
// }
