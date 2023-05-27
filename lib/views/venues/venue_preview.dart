import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/utilities/widgets/image_carousel.dart';
import 'package:venues/views/venues/venue_summary.dart';
import 'package:venues/views/venues/venues_list_view.dart';

class VenuePreview extends StatelessWidget {
  final Venue venue;
  final VenueCallback onTap;

  const VenuePreview({
    Key? key,
    required this.venue,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onTap(venue);
        },
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCarousel(imageUrls: venue.photoUrls),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: VenueSummary(venue: venue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> photos = [
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
    child: SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: Colors.blue,
        child: const Text('one'),
      ),
    ),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
    child: SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: Colors.green,
        child: const Text('two'),
      ),
    ),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
    child: SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: Colors.brown,
        child: const Text('three'),
      ),
    ),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
    child: SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: Colors.yellow,
        child: const Text('four'),
      ),
    ),
  ),
];
