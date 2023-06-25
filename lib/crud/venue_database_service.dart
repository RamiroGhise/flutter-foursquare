import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:venues/crud/database_constants.dart';
import 'package:venues/crud/database_exceptions.dart';
import 'package:venues/crud/database_venue_model.dart';

class VenuesDatabaseService {
  Database? _db;

  // make this class a Singleton so there aren't multiple sources
  // of truth when interacting with the database
  VenuesDatabaseService._sharedInstance();

  static final VenuesDatabaseService _shared =
      VenuesDatabaseService._sharedInstance();

  factory VenuesDatabaseService() {
    return _shared;
  }

  // read all venues from the database
  Future<Iterable<DatabaseVenue>> getAllVenues() async {
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

    final dbId = await db.insert(
      venuesTableName,
      {
        venuesTableRemoteIdColumn: venueId,
      },
    );

    return DatabaseVenue(
      id: dbId,
      venueId: venueId,
    );
  }

  // fetch a venue from the database
  Future<DatabaseVenue> getVenue({required String venueId}) async {
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

    return DatabaseVenue.fromRow(results.first);
  }

  // removes all venues from the database and returns the number of deleted entries
  Future<int> deleteAllVenues() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(venuesTableName);
  }

  // remove venue from the database and throw if the venue was not found
  Future<void> deleteVenue({required String venueId}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      venuesTableName,
      where: '$venuesTableRemoteIdColumn = ?',
      whereArgs: [venueId],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteVenue();
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
