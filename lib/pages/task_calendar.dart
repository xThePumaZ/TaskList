import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCalendar extends StatefulWidget {
  const TaskCalendar({super.key});

  @override
  State<TaskCalendar> createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2020, 1, 01),
          lastDay: DateTime.utc(2099, 1, 01)

      ),
    );
  }

}