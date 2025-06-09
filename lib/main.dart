import 'package:flutter/material.dart';
import 'package:task_list/pages/add_task.dart';
import 'package:task_list/pages/settings.dart';
import 'package:task_list/pages/task_calendar.dart';

import 'utilities/database_helper.dart';


import 'pages/task_overview.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(), // Use the new MainScreen widget
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index for the currently selected tab

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _widgetOptions;

  @override @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const TaskOverview(),
      AddTask(navigateToHome: () => _navigateToTab(0)), // Pass the callback
      const TaskCalendar(),
      Settings(),
    ];
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Overview';
      case 1:
        return 'New Task';
      case 2:
        return 'Calendar';
      case 3:
        return 'Settings';
      default:
        return 'Task App';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar can also be part of this MainScreen Scaffold if you want it
      // to be consistent across pages, or each page can define its own AppBar.
      // If defined here, the title might need to change based on _selectedIndex.
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getPageTitle(_selectedIndex)),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            activeIcon: Icon(Icons.checklist_rtl),
            label: 'Overview',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'New Task',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: "Calendar"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800], // Customize as needed
        unselectedItemColor: Colors.grey,     // Customize as needed
        onTap: _navigateToTab,
        // type: BottomNavigationBarType.fixed, // Optional: if you have many items
      ),
    );
  }

// Helper to get page title if AppBar is in MainScreen

}