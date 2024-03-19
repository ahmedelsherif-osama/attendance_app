import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordsWidget2 extends StatefulWidget {
  AttendanceRecordsWidget2(
      {required this.todaysDate, this.attendanceRecords, super.key});
  final DateTime todaysDate;
  Map<String, AttendanceRecordModel>? attendanceRecords;

  @override
  State<AttendanceRecordsWidget2> createState() =>
      _AttendanceRecordsWidget2State();
}

class _AttendanceRecordsWidget2State extends State<AttendanceRecordsWidget2> {
  DateTime? _date;
  List<StudentModel>? _students;

  @override
  void initState() {
    super.initState();
    _date = widget.todaysDate;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var datesDropDownMenuEntries = <DropdownMenuEntry<DateTime>>[];
    if (widget.attendanceRecords == null) {
      final thirtyDaysAgo =
          widget.todaysDate.subtract(const Duration(days: 30));
      for (var index = thirtyDaysAgo;
          index.isBefore(widget.todaysDate) || index == widget.todaysDate;
          index = thirtyDaysAgo.add(const Duration(days: 1))) {
        var bufferDateMenuEntry = DropdownMenuEntry(
            value: index, label: index.toString().substring(0, 10));
        datesDropDownMenuEntries.add(bufferDateMenuEntry);
      }
    } else {
      var minDate = widget.todaysDate.subtract(const Duration(days: 30));
      for (int index = 0; index < widget.attendanceRecords!.length; index++) {
        if (widget.attendanceRecords![index]!.date.isBefore(minDate)) {
          minDate = widget.attendanceRecords![index]!.date;
        }
      }

      final datesDropDownMenuEntries = List.generate(
          31,
          (index) => DropdownMenuEntry(
              value: minDate.add(Duration(days: index)),
              label: minDate
                  .add(Duration(days: index))
                  .toString()
                  .substring(0, 10)));
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            DropdownMenu(
              initialSelection: _date,
              dropdownMenuEntries: datesDropDownMenuEntries,
              onSelected: (value) {
                setState(() {
                  _date = value!;
                   FirebaseFirestore.instance.collection("students").get().then((value) => _students = value.docs; ); 
                });
              },
            ),
            SizedBox(height: height * 0.2),
            StudentListWithCheckBoxesWidget(
                students: _students,
                attendanceCheckBoxes: _attendanceCheckBoxes),
            SizedBox(height: height * 0.2),
            TextButton(onPressed: () {}, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
