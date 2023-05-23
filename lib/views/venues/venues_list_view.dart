import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/views/venues/venue_preview.dart';

class VenuesListView extends StatefulWidget {
  final List<Venue> venues;

  const VenuesListView({Key? key, required this.venues}) : super(key: key);

  @override
  State<VenuesListView> createState() => _VenuesListViewState();
}

class _VenuesListViewState extends State<VenuesListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final venues = widget.venues;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: venues.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        final venue = venues.elementAt(index);
        return VenuePreview(
          venue: venue,
        );
      },
    );
  }
}
