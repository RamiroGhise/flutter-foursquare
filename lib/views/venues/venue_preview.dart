import 'package:flutter/material.dart';
import 'package:venues/constants/routes.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/utilities/widgets/image_carousel.dart';

class VenuePreview extends StatelessWidget {
  final Venue venue;

  const VenuePreview({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(venueDetailsRoute);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${venue.rating.toString()} / 10'),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16.0,
                        ),
                        Text('(${venue.stats.totalRatings} reviews)')
                      ],
                    ),
                    Text(
                        '${venue.categories.first.name} | ${venue.distanceToVenue} m'),
                  ],
                ),
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
