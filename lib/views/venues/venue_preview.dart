import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';

class VenuePreview extends StatelessWidget {
  final Venue venue;

  const VenuePreview({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: photos,
                  ),
                ),
              ),
              Text(
                venue.name,
                overflow: TextOverflow.ellipsis,
              ),
              Text('${venue.rating.toString()} / 10 (${venue.stats.totalRatings} reviews)'),
              Text(
                  '${venue.categories.first.name} | ${venue.distanceToVenue} m'),
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
