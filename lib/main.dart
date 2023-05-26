import 'package:flutter/material.dart';
import 'package:venues/constants/routes.dart';
import 'package:venues/views/venues/venue_details_view.dart';
import 'package:venues/views/venues/venues_view.dart';
import 'package:venues/redux/app_state.dart';
import 'package:venues/redux/middleware.dart';
import 'package:venues/redux/reducer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        venueDetailsRoute: (context) => const VenueDetailsView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Store(
      reducer,
      initialState: const AppState.empty(),
      middleware: [
        loadVenuesMiddleware,
      ],
    );
    return StoreProvider<AppState>(
      store: store,
      child: const VenuesView(),
    );
  }
}
