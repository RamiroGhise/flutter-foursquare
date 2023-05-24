import 'dart:io';
import 'package:flutter/material.dart';
import 'package:venues/services/location/location_exceptions.dart';
import 'package:venues/services/location/location_service.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/utilities/show_error_dialog.dart';
import 'package:venues/views/venues/venues_list_view.dart';
import 'dart:developer' as devtools show log;

class VenuesView extends StatefulWidget {
  const VenuesView({Key? key}) : super(key: key);

  @override
  State<VenuesView> createState() => _VenuesViewState();
}

class _VenuesViewState extends State<VenuesView> {
  List<Venue> venuesList = [];
  late final LocationService _location;
  late final TextEditingController _search;
  late final TextEditingController _radius;

  @override
  void initState() {
    _search = TextEditingController();
    _radius = TextEditingController();
    _location = LocationService.foursquare();
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
                  try {
                    venuesList = await LocationService.foursquare().getVenues(
                        searchQuery: searchQuery, searchRadius: radius);
                  } on BadRequestLocationException catch (e) {
                    showErrorDialog(context, e.text);
                  } on UnauthorizedLocationException catch (e) {
                    showErrorDialog(context, e.text);
                  } on SocketException catch (e) {
                    showErrorDialog(context, e.message);
                  } on NoVenuesFoundLocationException {
                    showErrorDialog(context,
                        'No venues found. Please consider increasing the search radius');
                  } catch (e) {
                    showErrorDialog(context, e.toString());
                  }
                },
                child: const Text(
                  'Find venues',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Venue>>(
                stream: _location.venues,
                builder: (context, AsyncSnapshot<List<Venue>> snapshot) {
                  // devtools.log("has data: ${snapshot.data.toString()}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show Waiting Indicator
                    return Container();
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text("Error occurred");
                    } else if (snapshot.hasData) {
                      List<Venue>? venues = snapshot.data;
                      if (venues != null) {
                        return VenuesListView(venues: venues);
                      } else {
                        return Container();
                      }
                    }

                    return const Text("No Data Received");
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Change notifier holds on to the state of the search fields.
class SearchData extends ChangeNotifier {
  String _venueName = '';
  double _radius = 0.0;

  double get radius => _radius;

  String get venueName => _venueName;

  set radius(double newValue) {
    if (newValue != _radius) {
      _radius = newValue;
      notifyListeners();
    }
  }
}

final searchData = SearchData();

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
