import 'package:flutter/material.dart';

class VenueDetailsView extends StatelessWidget {
  const VenueDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('details'),
      ),
      body: const Text('here are the venue\'s details'),
    );
  }
}
