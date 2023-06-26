import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:venues/crud/database_constants.dart';
import 'package:venues/crud/database_exceptions.dart';
import 'package:venues/crud/database_venue_model.dart';
import 'dart:developer' as devtools show log;

class VenuesDatabaseService {
  Database? _db;

  List<DatabaseVenue> _venues = [];
  late final StreamController<List<DatabaseVenue>> _venuesStreamController;

  // make this class a Singleton so there aren't multiple sources
  // of truth when interacting with the database
  VenuesDatabaseService._sharedInstance() {
    _venuesStreamController = StreamController<List<DatabaseVenue>>.broadcast(
      // called whenever a new listener subscribes to this [StreamController]
      onListen: () {
        _venuesStreamController.sink.add(_venues);
      },
    );
  }

  static final VenuesDatabaseService _shared =
      VenuesDatabaseService._sharedInstance();

  factory VenuesDatabaseService() {
    return _shared;
  }

  Stream<List<DatabaseVenue>> get allVenues => _venuesStreamController.stream;

  // add the content of the db to the stream
  Future<void> _cacheVenues() async {
    final allVenues = await getAllVenues();
    _venues = allVenues.toList();
    _venuesStreamController.add(_venues);
  }

  // read all venues from the database
  Future<Iterable<DatabaseVenue>> getAllVenues() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final venues = await db.query(
      venuesTableName,
    );

    final result = venues.map((e) => DatabaseVenue.fromRow(e));

    return result;
  }

  // create a venue in the database
  // Create venue in the database, throw [VenueAlreadyExists] if a venue already
  // exists with the same remoteId.
  Future<DatabaseVenue> createVenue({required String venueId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      venuesTableName,
      limit: 1,
      where: '$venuesTableRemoteIdColumn = ?',
      whereArgs: [venueId],
    );
    // make sure the venue does not exist in the database
    if (results.isNotEmpty) {
      throw VenueAlreadyExists();
    }
    // create venue entry in db
    final dbId = await db.insert(
      venuesTableName,
      {
        venuesTableRemoteIdColumn: venueId,
      },
    );

    final databaseVenue = DatabaseVenue(
      id: dbId,
      venueId: venueId,
    );
    devtools.log('createVenue => $databaseVenue');

    // add the venue to the stream
    _venues.add(databaseVenue);
    _venuesStreamController.add(_venues);

    return databaseVenue;
  }

  // fetch a venue from the database
  Future<DatabaseVenue> getVenue({required String venueId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // results is a list of rows
    final results = await db.query(
      venuesTableName,
      limit: 1,
      where: '$venuesTableRemoteIdColumn = ?',
      whereArgs: [venueId],
    );
    if (results.isEmpty) {
      throw CouldNotFindVenue();
    }
    final venue = DatabaseVenue.fromRow(results.first);
    // update the cache with the value from the db
    _venues.removeWhere((venue) => venue.venueId == venueId);
    _venues.add(venue);
    _venuesStreamController.add(_venues);
    devtools.log('getVenue => $venue');

    return venue;
  }

  // removes all venues from the database and returns the number of deleted entries
  Future<int> deleteAllVenues() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(venuesTableName);
    _venues = [];
    _venuesStreamController.add(_venues);
    devtools.log('deleteAllVenues => deleted $numberOfDeletions rows');

    return numberOfDeletions;
  }

  // remove venue from the database and throw if the venue was not found
  Future<void> deleteVenue({required String venueId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      venuesTableName,
      where: '$venuesTableRemoteIdColumn = ?',
      whereArgs: [venueId],
    );
    // count should be 1
    if (deletedCount != 1) {
      throw CouldNotDeleteVenue();
    } else {
      _venues.removeWhere((venue) => venue.venueId == venueId);
      _venuesStreamController.add(_venues);
      devtools.log('deleteVenue => deleted venue $venueId');
    }
  }

  // open the database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the venues table
      await db.execute(createVenuesTable);
      // after opening the database, read it's content
      await _cacheVenues();
      devtools.log('open => database opened');
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  // helper function to check if the db is open before performing CRUD operations
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // do nothing if the db is already open
    }
  }

  // helper function to check for db existence before performing db operations
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // close the database
  Future<void> close() async {
    final db = _getDatabaseOrThrow();
    await db.close();
    _db = null;
  }
}
