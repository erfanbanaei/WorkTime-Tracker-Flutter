import 'package:flutter/material.dart';
import 'package:jalali_flutter_datepicker/jalali_flutter_datepicker.dart'
    as picker;
import 'package:timework/main.dart';
import 'package:timework/models/time_entry.dart';
import 'package:shamsi_date/shamsi_date.dart' as shamsi;

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedMonth;
  DateTime? selectedDate;
  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;

  final List<String> persianMonths = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];
  bool isLeave = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت ورود و خروج جدید'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(26),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'امروز: ${shamsi.Jalali.now().formatter.yyyy}/${shamsi.Jalali.now().formatter.mm}/${shamsi.Jalali.now().formatter.dd}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedMonth,
                    decoration: InputDecoration(
                      labelText: 'ماه',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    items:
                        persianMonths.map((String month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog<picker.Jalali>(
                        context: context,
                        builder:
                            (context) => Dialog(
                              child: SizedBox(
                                height: 600,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 500,
                                        child: picker.JalaliFlutterDatePicker(
                                          onDateChanged: (date) {
                                            setState(() {
                                              selectedDate = date!.toDateTime();
                                            });
                                          },
                                          initialDate: picker.Jalali.now(),
                                          firstDateRange: picker.Jalali(1380),
                                          lastDateRange: picker.Jalali(1410),
                                          disabledDayColor:
                                              Colors.grey.shade300,
                                          enabledDayColor: Colors.black,
                                          selectedDayBackground:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          selectedDayColor: Colors.white,
                                          todayColor: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(179),
                                          footerIconColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          footerTextStyle: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          headerTextStyle: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          selectedMonthTextStyle:
                                              const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                          monthDropDownItemTextStyle:
                                              const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                              ),
                                          selectedYearTextStyle:
                                              const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                          yearsDropDownItemTextStyle:
                                              const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                              ),
                                          customArrowWidget: Icon(
                                            Icons.arrow_drop_down,
                                            size: 30,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                          overlayColor:
                                              const WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                        ),
                                        child: Text(
                                          "تایید",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(
                      selectedDate != null
                          ? 'تاریخ: ${shamsi.Jalali.fromDateTime(selectedDate!).formatter.yyyy}/${shamsi.Jalali.fromDateTime(selectedDate!).formatter.mm}/${shamsi.Jalali.fromDateTime(selectedDate!).formatter.dd}'
                          : 'انتخاب تاریخ',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          checkInTime = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(
                      Icons.login,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: Text(
                      checkInTime != null
                          ? 'ساعت ورود: ${checkInTime?.format(context)}'
                          : 'ساعت ورود',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          checkOutTime = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: Text(
                      checkOutTime != null
                          ? 'ساعت خروج: ${checkOutTime?.format(context)}'
                          : 'ساعت خروج',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    value: isLeave,
                    onChanged: (value) {
                      setState(() {
                        isLeave = value ?? false;
                      });
                    },
                    title: const Text('مرخصی'),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedMonth != null &&
                          selectedDate != null &&
                          checkInTime != null &&
                          checkOutTime != null) {
                        final entry = TimeEntry(
                          month: selectedMonth!,
                          date:
                              '${shamsi.Jalali.fromDateTime(selectedDate!).formatter.yyyy}/${shamsi.Jalali.fromDateTime(selectedDate!).formatter.mm}/${shamsi.Jalali.fromDateTime(selectedDate!).formatter.dd}',
                          checkIn: checkInTime!.format(context),
                          checkOut: checkOutTime!.format(context),
                          isLeave: isLeave, // Add this field
                        );

                        await database.timeEntryDao.insertTimeEntry(entry);
                        if (mounted) {
                          if (context.mounted) Navigator.pop(context, true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'ذخیره',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
