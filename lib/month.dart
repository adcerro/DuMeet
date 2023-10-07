import 'package:flutter/material.dart';

class Month extends StatelessWidget {
  int days = 31;
  Month({super.key, int num = 1, int year = 2023}) {
    days = dayCount(num, year);
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: days,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            '${index + 1}', // Replace with actual date for that day
          ),
        );
      },
    );
  }
}
