import 'package:flutter/material.dart';
import 'screens/add_entry_screen.dart';
import 'screens/month_details_screen.dart';
import 'database/database.dart';
import 'models/time_entry.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await buildDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeWork',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "IRANSans",
        primaryColor: const Color(0xFF1B1B3A), // Navy blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B1B3A),
          primary: const Color(0xFF1B1B3A), // Navy blue
          secondary: const Color(0xFFDAA520), // Golden
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B1B3A),
            foregroundColor: const Color(0xFFDAA520),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت ساعت کاری'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        label: const Text('ثبت ورود و خروج'),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<String>>(
        future: _getMonthsWithEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final monthsWithEntries = snapshot.data!;

          if (monthsWithEntries.isEmpty) {
            return const Center(
              child: Text(
                'هیچ اطلاعاتی ثبت نشده است',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: monthsWithEntries.length,
            itemBuilder: (context, index) {
              return _buildMonthCard(monthsWithEntries[index]);
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getMonthsWithEntries() async {
    List<String> result = [];
    for (String month in persianMonths) {
      final entries = await database.timeEntryDao.findEntriesByMonth(month);
      if (entries.isNotEmpty) {
        result.add(month);
      }
    }
    return result;
  }

  Widget _buildMonthCard(String month) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonthDetailsScreen(month: month),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withAlpha(179),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<TimeEntry>>(
                future: database.timeEntryDao.findEntriesByMonth(month),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data!.length} مورد',
                      style: const TextStyle(color: Colors.white70),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
