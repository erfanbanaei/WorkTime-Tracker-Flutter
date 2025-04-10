import 'package:flutter/material.dart';
import 'package:timework/main.dart';
import 'package:timework/models/time_entry.dart';
import 'package:timework/widgets/time_entry_card.dart'; // Add this import

class MonthDetailsScreen extends StatelessWidget {
  final String month;

  const MonthDetailsScreen({super.key, required this.month});

  String calculateTotalHours(List<TimeEntry> entries) {
    int totalMinutes = 0;
    for (var entry in entries) {
      // Calculate hours for both regular work and leave
      final checkIn = _parseTimeString(entry.checkIn);
      final checkOut = _parseTimeString(entry.checkOut);

      int minutes =
          (checkOut.hour * 60 + checkOut.minute) -
          (checkIn.hour * 60 + checkIn.minute);
      totalMinutes += minutes;
    }

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return '$hours ساعت و $minutes دقیقه';
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final cleanStr = timeStr.replaceAll(' AM', '').replaceAll(' PM', '');
    final parts = cleanStr.split(':');
    var hour = int.parse(parts[0]);

    if (timeStr.contains('PM') && hour != 12) hour += 12;
    if (timeStr.contains('AM') && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(month),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<TimeEntry>>(
        future: database.timeEntryDao.findEntriesByMonth(month),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('هیچ اطلاعاتی برای این ماه ثبت نشده است'),
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'جمع ساعات کاری: ${calculateTotalHours(snapshot.data!)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      return TimeEntryCard(
                        entry: entry,
                        onDeleted: () {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('مورد با موفقیت حذف شد'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
