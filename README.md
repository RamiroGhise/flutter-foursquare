# flutter-foursquare

Flutter mobile app to display a list of venues around a user's location. Uses [Foursquare's place search API](https://location.foursquare.com/developer/reference/place-search) to get the venues information and the custom Flutter plugin [current-location](https://github.com/RamiroGhise/current-location) to get the current location on Andoid and iOS.

- Uses BLoC on the [bloc_architecture](https://github.com/RamiroGhise/flutter-foursquare/tree/bloc_architecture) branch and Redux on the [main](https://github.com/RamiroGhise/flutter-foursquare/tree/main) branch.
## Features

- Adjust the radius of interest.

## Installation
1. Create a Foursquare project and generate an API key [(Foursquare guide)](https://location.foursquare.com/developer/reference/places-api-get-started).
2. Change API key from [foursquare.dart](https://github.com/RamiroGhise/flutter-foursquare/blob/main/lib/constants/foursquare.dart) with your newly generated key.
3. Run the project. 
