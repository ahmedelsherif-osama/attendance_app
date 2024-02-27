import 'package:final_rta_attendance/models/4_attendace_record_model.dart';
import 'package:flutter/material.dart';

class AttendanceRecordsWidget extends StatefulWidget {
  const AttendanceRecordsWidget({
    required this.attendanceRecords,
    Key? key,
  }) : super(key: key);

  final List<AttendanceRecordModel> attendanceRecords;

  @override
  State<AttendanceRecordsWidget> createState() =>
      _AttendanceRecordsWidgetState();
}

class _AttendanceRecordsWidgetState extends State<AttendanceRecordsWidget> {
  late DateTime _currentDate;
  late List<AttendanceRecordModel> _currentAttendanceRecords;

  findMinDate(dates) {
    var minDate;
    for (int index = 0; index < dates.length; index++) {
      if (index == 0) {
        minDate = dates[index];
      } else {
        if (dates[index] < minDate) {
          minDate = dates[index];
        }
      }
    }
    return minDate;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the state with the provided date and attendanceRecords
    _currentAttendanceRecords = widget.attendanceRecords;
    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Your build method implementation here
    final height = MediaQuery.of(context).size.height;
    const existingDates = [];
    _currentAttendanceRecords.forEach(
      (element) {
        existingDates.add(element.date);
      },
    );
    var existingDatesFirstDate = findMinDate(existingDates);

    var sixMonthsBeforeFirstDate = existingDatesFirstDate - 180;
    var firstDate = sixMonthsBeforeFirstDate;
    var lastDate = DateTime.now();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            CalendarDatePicker(
                initialDate: _currentDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (date) {
                  setState(() {
                    _currentDate = date;
                  });
                })
          ],
        ),
      ),
    );
  }
}
