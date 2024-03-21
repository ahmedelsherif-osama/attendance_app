import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordsWidget extends StatefulWidget {
  AttendanceRecordsWidget(
      {required this.todaysDate, this.attendanceRecords, super.key});
  final DateTime todaysDate;
  Map<String, AttendanceRecordModel>? attendanceRecords;

  @override
  State<AttendanceRecordsWidget> createState() =>
      _AttendanceRecordsWidget2State();
}

class _AttendanceRecordsWidget2State extends State<AttendanceRecordsWidget> {
  DateTime? _date;
  List<String>? _studentIDs = [];

  @override
  void initState() {
    super.initState();
    _date = widget.todaysDate;
    widget.attendanceRecords!.forEach((key, value) {
      print("init state ${key}");
      print(value.date);
      print(widget.todaysDate);
    });
    print(widget.attendanceRecords!.entries.first.key);
    if (widget.attendanceRecords!.entries.contains((element) =>
        element.value.date.toString().substring(0, 9) ==
        widget.todaysDate.toString().substring(0, 9))) {
      _studentIDs = widget.attendanceRecords!.entries
          .singleWhere((element) => element.value.date == widget.todaysDate)
          .value
          .studentAttendanceCheckboxes
          .keys
          .toList();
      print("init state ${_studentIDs}");
    } else {
      _studentIDs = context.read<AppCubit>().state.currentBusRoute.studentsIDs;
      var bufferStudentAttendanceCheckboxes = new Map<String, dynamic>();
      _studentIDs!.forEach((Element) {
        bufferStudentAttendanceCheckboxes[Element] = false;
      });
      var oldState = context.read<AppCubit>().state;
      var bufferAttendanceRecord = AttendanceRecordModel(
        schoolName: context.read<AppCubit>().state.currentSchool.name,
        busRouteNumber: context
            .read<AppCubit>()
            .state
            .currentBusRoute
            .busRouteNumber
            .toString(),
        studentAttendanceCheckboxes: bufferStudentAttendanceCheckboxes,
        date: _date!,
      );
      context.read<AppCubit>().updateState(
          oldState.copyWith(currentAttendanceRecord: bufferAttendanceRecord));

      print("init state ${_studentIDs}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("inside build");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var datesDropDownMenuEntries = <DropdownMenuEntry<DateTime>>[];
    print("before if");
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
      print("attendance records not null");
      var minDate = widget.todaysDate.subtract(const Duration(days: 30));
      print("widget's attendance records ${widget.attendanceRecords}");
      print("widget's attendance records ${widget.attendanceRecords}");

      widget.attendanceRecords!.forEach((key, value) {
        if (value.date.isBefore(minDate)) {
          minDate = value.date;
        }
      });

      print("after for");

      datesDropDownMenuEntries = List.generate(
          31,
          (index) => DropdownMenuEntry(
              value: minDate.add(Duration(days: index)),
              label: minDate
                  .add(Duration(days: index))
                  .toString()
                  .substring(0, 10)));
      print("inside else ${datesDropDownMenuEntries.first.label}");
    }
    print("outside else ${datesDropDownMenuEntries.first.label}");
    print("date ${_date}");
    print("datesDropDownMnuEntries ${datesDropDownMenuEntries.isEmpty}");
    print(height);

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
                  print("inside set state");
                  _date = value!;
                  print("date assignment is fine");
                  print(_date);
                  var bufferStudentIDList = widget.attendanceRecords!.entries
                      .firstWhere((element) =>
                          element.value.date.toString().substring(0, 9) ==
                          _date.toString().substring(0, 9))
                      .value
                      .studentAttendanceCheckboxes
                      .keys
                      .toList();
                  _studentIDs = bufferStudentIDList;
                  print("buffer student id list ${bufferStudentIDList}");
                  var attendanceRecord = widget.attendanceRecords!.values
                      .where((element) =>
                          element.date.toString().substring(0, 9) ==
                          _date.toString().substring(0, 9))
                      .first;
                  context.read<AppCubit>().updateState(context
                      .read<AppCubit>()
                      .state
                      .copyWith(currentAttendanceRecord: attendanceRecord));
                  var studentsIDs = context
                      .read<AppCubit>()
                      .state
                      .currentAttendanceRecord
                      .studentAttendanceCheckboxes
                      .keys;
                  // FirebaseFirestore.instance
                  //     .collection("students")
                  //     .where("studentsIDs", whereIn: studentsIDs)
                  //     .get()
                  //     .then((value) => value.docs.forEach((element) {
                  //           _students!
                  //               .add(StudentModel.fromJson(element.data()));
                  //         }));
                });
              },
            ),
            SizedBox(height: height * 0.2),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("students")
                    .where("studentID", whereIn: _studentIDs)
                    .where("schoolName",
                        isEqualTo:
                            context.read<AppCubit>().state.currentSchool.name)
                    .where("busRouteNumber",
                        isEqualTo: context
                            .read<AppCubit>()
                            .state
                            .currentBusRoute
                            .busRouteNumber
                            .toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  print(_studentIDs);
                  print("inside builder...");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Text(
                        "Error: ${snapshot.error}"); // Show error message
                  } else {
                    var students = <StudentModel>[];
                    snapshot.data!.docs.forEach((element) {
                      students.add(StudentModel.fromJson(
                          element.data() as Map<String, dynamic>));
                    });
                    print(students.first.schoolName);
                    print(context
                        .read<AppCubit>()
                        .state
                        .currentAttendanceRecord
                        .studentAttendanceCheckboxes);
                    return Expanded(
                      child: StudentListWithCheckBoxesWidget(
                        students: students,
                        attendanceCheckBoxes: context
                            .read<AppCubit>()
                            .state
                            .currentAttendanceRecord
                            .studentAttendanceCheckboxes,
                      ),
                    );
                  }
                }),
            SizedBox(height: height * 0.2),
            TextButton(onPressed: () {}, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
