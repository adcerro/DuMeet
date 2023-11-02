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
          weekendStyle: TextStyle(fontFamily: font)),
      calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
              color: Theme.of(context).hintColor, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, shape: BoxShape.circle)),
    );
  }
}

Dialog dialog(
    {required BuildContext context,
    IconData iconData = Icons.question_answer,
    String text = ''}) {
  return Dialog(
    child: Column(
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

Dialog successDialog({required BuildContext context, String text = ''}) {
  return dialog(context: context, iconData: Icons.check, text: text);
}

Dialog errorDialog({required BuildContext context, String text = ''}) {
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
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey.withOpacity(0.1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
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
      onPressed: () {
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
