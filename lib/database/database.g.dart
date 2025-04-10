// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TimeEntryDao? _timeEntryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TimeEntry` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `month` TEXT NOT NULL, `date` TEXT NOT NULL, `checkIn` TEXT NOT NULL, `checkOut` TEXT NOT NULL, `isLeave` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TimeEntryDao get timeEntryDao {
    return _timeEntryDaoInstance ??= _$TimeEntryDao(database, changeListener);
  }
}

class _$TimeEntryDao extends TimeEntryDao {
  _$TimeEntryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _timeEntryInsertionAdapter = InsertionAdapter(
            database,
            'TimeEntry',
            (TimeEntry item) => <String, Object?>{
                  'id': item.id,
                  'month': item.month,
                  'date': item.date,
                  'checkIn': item.checkIn,
                  'checkOut': item.checkOut,
                  'isLeave': item.isLeave ? 1 : 0
                },
            changeListener),
        _timeEntryDeletionAdapter = DeletionAdapter(
            database,
            'TimeEntry',
            ['id'],
            (TimeEntry item) => <String, Object?>{
                  'id': item.id,
                  'month': item.month,
                  'date': item.date,
                  'checkIn': item.checkIn,
                  'checkOut': item.checkOut,
                  'isLeave': item.isLeave ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TimeEntry> _timeEntryInsertionAdapter;

  final DeletionAdapter<TimeEntry> _timeEntryDeletionAdapter;

  @override
  Future<List<TimeEntry>> findAllTimeEntries() async {
    return _queryAdapter.queryList('SELECT * FROM TimeEntry',
        mapper: (Map<String, Object?> row) => TimeEntry(
            id: row['id'] as int?,
            month: row['month'] as String,
            date: row['date'] as String,
            checkIn: row['checkIn'] as String,
            checkOut: row['checkOut'] as String,
            isLeave: (row['isLeave'] as int) != 0));
  }

  @override
  Stream<List<TimeEntry>> findEntriesByMonthStream(String month) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM TimeEntry WHERE month = ?1',
        mapper: (Map<String, Object?> row) => TimeEntry(
            id: row['id'] as int?,
            month: row['month'] as String,
            date: row['date'] as String,
            checkIn: row['checkIn'] as String,
            checkOut: row['checkOut'] as String,
            isLeave: (row['isLeave'] as int) != 0),
        arguments: [month],
        queryableName: 'TimeEntry',
        isView: false);
  }

  @override
  Future<List<TimeEntry>> findEntriesByMonth(String month) async {
    return _queryAdapter.queryList('SELECT * FROM TimeEntry WHERE month = ?1',
        mapper: (Map<String, Object?> row) => TimeEntry(
            id: row['id'] as int?,
            month: row['month'] as String,
            date: row['date'] as String,
            checkIn: row['checkIn'] as String,
            checkOut: row['checkOut'] as String,
            isLeave: (row['isLeave'] as int) != 0),
        arguments: [month]);
  }

  @override
  Future<void> insertTimeEntry(TimeEntry timeEntry) async {
    await _timeEntryInsertionAdapter.insert(
        timeEntry, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTimeEntry(TimeEntry entry) async {
    await _timeEntryDeletionAdapter.delete(entry);
  }
}
