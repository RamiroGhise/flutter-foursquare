const dbName = 'venues.db';
const venuesTableName = 'venue';
const venuesTableIdColumn = 'id';
// venue id taken from the venues location provider [FoursquareLocationProvider]
const venuesTableRemoteIdColumn = 'remoteId';

// command to create the 'venue' table with
// 'id' as primary key with autoincrement,
// 'providerId' as a unique value.
const createVenuesTable = '''
  CREATE TABLE IF NOT EXISTS "$venuesTableName" (
    "id" INTEGER NOT NULL,
    "remoteId" TEXT NOT NULL UNIQUE,
  );
''';