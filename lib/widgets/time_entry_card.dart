import 'package:flutter/material.dart';
import 'package:timework/models/time_entry.dart';
import 'package:timework/main.dart';

class TimeEntryCard extends StatelessWidget {
  final TimeEntry entry;
  final VoidCallback onDeleted;

  const TimeEntryCard({
    super.key,
    required this.entry,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: entry.isLeave ? Colors.red.shade50 : null,
      child: Dismissible(
        key: Key(entry.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) async {
          await database.timeEntryDao.deleteTimeEntry(entry);
          onDeleted();
        },
        child: ListTile(
          title: Text(
            'تاریخ: ${entry.date}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Icon(
                entry.isLeave ? Icons.event_busy : Icons.login,
                color:
                    entry.isLeave ? Colors.red : Theme.of(context).primaryColor,
              ),
              Text(' ورود: ${_formatTime(entry.checkIn)}'),
              const SizedBox(width: 16),
              Icon(
                entry.isLeave ? Icons.event_busy : Icons.logout,
                color:
                    entry.isLeave ? Colors.red : Theme.of(context).primaryColor,
              ),
              Text(' خروج: ${_formatTime(entry.checkOut)}'),
              if (entry.isLeave) ...[
                const SizedBox(width: 16),
                const Text('(مرخصی)', style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    final cleanStr = time.replaceAll(' AM', '').replaceAll(' PM', '');
    final parts = cleanStr.split(':');
    var hour = int.parse(parts[0]);

    if (time.contains('PM') && hour != 12) hour += 12;
    if (time.contains('AM') && hour == 12) hour = 0;

    return '${hour.toString().padLeft(2, '0')}:${parts[1]}';
  }
}
