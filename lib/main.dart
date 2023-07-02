import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/venues_bloc.dart';
import 'package:venues/constants/routes.dart';
import 'package:venues/views/venues/favorite_venues_view.dart';
import 'package:venues/views/venues/venue_details_view.dart';
import 'package:venues/views/venues/venues_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VenuesBloc>(
      create: (context) => VenuesBloc()..add(const InitializeBookmarksAction()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          venueDetailsRoute: (context) => const VenueDetailsView(),
          favoriteVenuesRoute: (context) => const FavoriteVenuesView(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const VenuesView();
  }
}
