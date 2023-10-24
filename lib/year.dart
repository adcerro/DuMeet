import 'package:calendar/month.dart';
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:infinite_listview/infinite_listview.dart';

int _year = DateTime.now().year;

class Year extends StatefulWidget {
  const Year({super.key});
  @override
  State<Year> createState() => _YearState();
}

class _YearState extends State<Year> {
  @override
  Widget build(BuildContext context) {
    //Get the total height of the screen of the device
    double height = MediaQuery.sizeOf(context).height;
    //The Widgets get organized vertically
    return Column(children: [
      Container(
          color: Theme.of(context).hintColor,
          height: height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _year--;
                  });
                },
                icon: Icon(Icons.arrow_left,
                    size: height * 0.025,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        DialogRoute(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: InfiniteListView.builder(
                                    itemBuilder: (context, index) {
                                  return TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _year = _year + index;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('${_year + index}'));
                                }),
                              );
                            }));
                  },
                  child: Text(
                    _year.toString(),
                    style: TextStyle(
                        fontSize: height * 0.025,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )),
              IconButton(
                onPressed: () {
                  setState(() {
                    _year++;
                  });
                },
                icon: Icon(Icons.arrow_right,
                    size: height * 0.025,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          )),
      Expanded(
          child: LoopPageView.builder(
              itemBuilder: (context, index) {
                return Month(
                    num: (DateTime.now().month - 1 + index) % 12 + 1,
                    year: _year);
              },
              itemCount: 12))
    ]);
  }
}
