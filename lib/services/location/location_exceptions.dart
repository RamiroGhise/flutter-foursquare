// Location exceptions
class UnauthorizedLocationException implements Exception {
  final String text;

  UnauthorizedLocationException(this.text);
}

class BadRequestLocationException implements Exception {
  final String text;

  BadRequestLocationException(this.text);
}

class NoVenuesFoundLocationException implements Exception {

}