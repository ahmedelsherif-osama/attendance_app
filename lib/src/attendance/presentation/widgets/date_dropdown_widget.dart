import 'package:flutter/material.dart';

class DateDropDown extends StatefulWidget {
  @override
  State<DateDropDown> createState() => _DateDropDownState();
}

class _DateDropDownState extends State<DateDropDown> {
  final List<DropdownMenuItem<DateTime>> dateList = List.generate(
    5,
    (index) {
      DateTime currentDate = DateTime.now().subtract(Duration(days: index));
      DateTime dateWithoutTime =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      return DropdownMenuItem<DateTime>(
        value: dateWithoutTime,
        child: Text(
          dateWithoutTime.toString().substring(0, 10),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<DateTime>(
        items: dateList,
        onChanged: (DateTime? selectedDate) {
          // Handle the selected date here
        },
        hint: Text(
          DateTime.now().toString().substring(0, 10),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
