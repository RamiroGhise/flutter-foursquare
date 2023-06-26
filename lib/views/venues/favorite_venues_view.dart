import 'package:flutter/material.dart';
import 'package:venues/crud/database_venue_model.dart';
import 'package:venues/crud/venue_database_service.dart';
import 'dart:developer' as devtools show log;

class FavoriteVenuesView extends StatefulWidget {
  const FavoriteVenuesView({Key? key}) : super(key: key);

  @override
  State<FavoriteVenuesView> createState() => _FavoriteVenuesViewState();
}

class _FavoriteVenuesViewState extends State<FavoriteVenuesView> {
  late final VenuesDatabaseService _venuesDbService;

  @override
  void initState() {
    _venuesDbService = VenuesDatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved venues'),
      ),
      body: StreamBuilder(
        stream: _venuesDbService.allVenues,
        builder: (context, AsyncSnapshot<List<DatabaseVenue>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final allVenues = snapshot.data as List<DatabaseVenue>;
                devtools.log('got all venues: $allVenues');
                return ListView.builder(
                  itemCount: allVenues.length,
                  itemBuilder: (context, index) {
                    final venue = allVenues[index];
                    return ListTile(
                      title: Text(venue.venueId),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
