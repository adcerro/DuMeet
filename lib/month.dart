import 'package:flutter/material.dart';

class Month extends StatelessWidget {
  int _days = 31;
  int _num = 1;
  Month({super.key, int num = 1, int year = 2023}) {
    _days = dayCount(num, year);
    _num = num;
  }
  bool isLeap(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  int dayCount(int month, int year) {
    if (month == 2) {
      if (isLeap(year)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else {
      return 31;
    }
  }

  String monthName(int num) {
    switch (num) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'January';
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titles = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
    return Column(children: [
      Container(
          color: Colors.red,
          child: Column(children: [
            const SizedBox(height: 10),
            Center(
                child: Text(
              monthName(_num),
              style: titles.copyWith(fontSize: 30),
            )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sun', style: titles),
                Text('Mon', style: titles),
                Text('Tue', style: titles),
                Text('Wed', style: titles),
                Text('Thu', style: titles),
                Text('Fri', style: titles),
                Text('Sat', style: titles),
              ],
            )
          ])),
      GridView.builder(
        itemCount: _days,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: MediaQuery.of(context).size.height / 5.5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              '${index + 1}', // Replace with actual date for that day
            ),
          );
        },
      )
    ]);
  }
}
