import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/views/venues/venue_preview.dart';

typedef VenueCallback = void Function(Venue venue);

class VenuesListView extends StatelessWidget {
  final List<Venue> venues;
  final VenueCallback onTap;

  const VenuesListView({
    Key? key,
    required this.venues,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: venues.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        final venue = venues.elementAt(index);
        return VenuePreview(
          venue: venue,
          onTap: onTap,
        );
      },
    );
  }
}
