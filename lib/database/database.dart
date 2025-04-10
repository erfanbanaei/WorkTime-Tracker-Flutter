import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:timework/database/time_entry_dao.dart';
import 'package:timework/models/time_entry.dart';

part 'database.g.dart';

@Database(version: 2, entities: [TimeEntry])
abstract class AppDatabase extends FloorDatabase {
  TimeEntryDao get timeEntryDao;

  static final migration1to2 = Migration(1, 2, (database) async {
    // Check if column exists before adding it
    final List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT COUNT(*) as count FROM pragma_table_info('TimeEntry') WHERE name='isLeave'"
    );
    final exists = result.first['count'] as int;
    
    if (exists == 0) {
      await database.execute(
        'ALTER TABLE TimeEntry ADD COLUMN isLeave INTEGER NOT NULL DEFAULT 0'
      );
    }
  });
}

Future<AppDatabase> buildDatabase() async {
  return await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([AppDatabase.migration1to2])
      .build();
}