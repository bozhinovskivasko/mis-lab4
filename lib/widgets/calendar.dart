import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:finki/model/list_item.dart';

class Calendar extends StatefulWidget {
  List<ListItem> kolokviumi = [];

  Calendar({Key? key, required this.kolokviumi}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventCalendar(
        calendarType: CalendarType.GREGORIAN,
        calendarLanguage: 'en',
        events: _getDataSource(widget.kolokviumi),
      ),
    );
  }
}

_getDataSource(List<ListItem> k) {
  final List<Event> events = <Event>[];
  for (var i = 0; i < k.length; i++) {
    var date = DateTime.parse(k[i].datum);
    events.add(Event(
      child: const Text('Test'),
      dateTime: CalendarDateTime(
        year: date.year,
        month: date.month,
        day: date.day,
        calendarType: CalendarType.GREGORIAN,
      ),
    ));
  }
  return events;
}
