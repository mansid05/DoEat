
import 'package:flutter/material.dart';
import 'package:food_app/Admin/admin_home_page.dart';
import 'package:food_app/Admin/admin_menu_page.dart';
import 'package:food_app/auth/login_page.dart';
import 'package:table_calendar/table_calendar.dart';


class ShowCalendar extends StatefulWidget {
  const ShowCalendar({super.key});

  @override
  State<ShowCalendar> createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {

  final int _selectedIndex=2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton:FloatingActionButton.large(
        onPressed: () {
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const LoginPage(),),(route) => false,);

          // debugPrint("Floating Action Button Pressed");
        },
        backgroundColor: Colors.amber,
        shape: ShapeBorder.lerp(
          const CircleBorder(),
          const StadiumBorder(),
          0.5,
        ),
        child: const Icon(Icons.logout),
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      body: Container(
        child: Column(
          children: [
            TableCalendar(
              dayHitTestBehavior: HitTestBehavior.deferToChild,
              calendarStyle: const CalendarStyle(),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {});
              },
              calendarFormat: CalendarFormat.month,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            )
          ],
        ),
      ),
    );
  }
}
