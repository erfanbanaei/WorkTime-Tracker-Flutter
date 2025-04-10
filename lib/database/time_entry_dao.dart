import 'package:floor/floor.dart';
import 'package:timework/models/time_entry.dart';

@dao
abstract class TimeEntryDao {
  @Query('SELECT * FROM TimeEntry')
  Future<List<TimeEntry>> findAllTimeEntries();

  @Query('SELECT * FROM TimeEntry WHERE month = :month')
  Stream<List<TimeEntry>> findEntriesByMonthStream(String month);

  @Query('SELECT * FROM TimeEntry WHERE month = :month')
  Future<List<TimeEntry>> findEntriesByMonth(String month);

  @insert
  Future<void> insertTimeEntry(TimeEntry timeEntry);

  @delete
  Future<void> deleteTimeEntry(TimeEntry entry);
}