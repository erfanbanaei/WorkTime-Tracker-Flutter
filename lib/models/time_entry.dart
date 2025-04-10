import 'package:floor/floor.dart';

@Entity(tableName: 'TimeEntry')
class TimeEntry {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String month;
  final String date;
  final String checkIn;
  final String checkOut;
  @ColumnInfo(name: 'isLeave')
  final bool isLeave;

  TimeEntry({
    this.id,
    required this.month,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    this.isLeave = false,
  });
}