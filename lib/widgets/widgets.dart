import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime _focusedDay = DateTime.now();
DateTime _selectedDay = DateTime.now();
void Function(DateTime, DateTime)? _onDatePicked;

class CustomCalendar extends StatefulWidget {
  CustomCalendar(
      {super.key,
      required DateTime focusedDay,
      required DateTime selectedDay,
      void Function(DateTime selectedDate, DateTime focusedDate)?
          onDatePicked}) {
    _focusedDay = focusedDay;
    _selectedDay = selectedDay;
    _onDatePicked = onDatePicked;
  }
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    String? font = Theme.of(context).textTheme.headlineSmall?.fontFamily;
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 90)),
      daysOfWeekHeight: MediaQuery.sizeOf(context).height/20,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        _onDatePicked!(selectedDay, focusedDay);
      },
      headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              fontFamily: font,
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize)),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontFamily: font),
          weekendStyle: TextStyle(fontFamily: font),
      ),
      calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
              color: Theme.of(context).hintColor, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, shape: BoxShape.circle)),
    );
  }
}

AlertDialog dialog(
    {required BuildContext context,
    IconData iconData = Icons.question_answer,
    String text = ''}) {
  return AlertDialog.adaptive(
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconData, size: 30),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

AlertDialog successDialog({required BuildContext context, String text = ''}) {
  return dialog(context: context, iconData: Icons.check, text: text);
}

AlertDialog errorDialog({required BuildContext context, String text = ''}) {
  return dialog(context: context, iconData: Icons.error, text: text);
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    obscureText: isPasswordType,
    autocorrect: !isPasswordType,
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xff000000),
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container uiButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () async {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Theme.of(context).primaryColor;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '02/02/23',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            '3:30am',
            style: const TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(3, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: 120,
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=843&q=80',
                  ),
                ),
              ),
            ),
          ),
          const Text(
            "Header Text",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "Body Text",
            style: TextStyle(),
          )
        ],
      ),
    );
  }
}
