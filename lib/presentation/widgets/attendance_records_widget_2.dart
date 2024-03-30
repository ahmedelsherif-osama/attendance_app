import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_app/cubit/app_cubit.dart';
import 'package:attendance_app/cubit/app_state.dart';
import 'package:attendance_app/models/3_student_model.dart';
import 'package:attendance_app/models/4_attendance_record_model.dart';
import 'package:attendance_app/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordsWidget extends StatefulWidget {
  AttendanceRecordsWidget({
    required this.todaysDate,
    this.attendanceRecords,
    super.key,
  });
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
    var docID = widget.attendanceRecords!.entries
        .where((element) =>
            element.value.date.toString().substring(0, 10) ==
            widget.todaysDate.toString().substring(0, 10))
        .first
        .key;
    var oldState = context.read<AppCubit>().state;
    context.read<AppCubit>().updateState(
        oldState.copyWith(currentAttendanceRecordFirebaseDocId: docID));

    if (widget.attendanceRecords!.entries.any((element) =>
        element.value.date.toString().substring(0, 10) ==
        widget.todaysDate.toString().substring(0, 10))) {
      var bufferStudentIDList = widget.attendanceRecords!.entries
          .firstWhere((element) =>
              element.value.date.toString().substring(0, 10) ==
              _date.toString().substring(0, 10))
          .value
          .studentAttendanceCheckboxes
          .keys
          .toList();
      _studentIDs = bufferStudentIDList;
      var attendanceRecord = widget.attendanceRecords!.values
          .where((element) =>
              element.date.toString().substring(0, 10) ==
              _date.toString().substring(0, 10))
          .first;
      var attendanceRecordFirebaseDocId = widget.attendanceRecords!.entries
          .firstWhere(
            (entry) =>
                entry.value.date.toString().substring(0, 10) ==
                _date.toString().substring(0, 10),
          )
          .key;
      context.read<AppCubit>().updateState(context
          .read<AppCubit>()
          .state
          .copyWith(
              currentAttendanceRecord: attendanceRecord,
              currentAttendanceRecordFirebaseDocId:
                  attendanceRecordFirebaseDocId));
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
    }
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

      widget.attendanceRecords!.forEach((key, value) {
        if (value.date.isBefore(minDate)) {
          minDate = value.date;
        }
      });

      datesDropDownMenuEntries = List.generate(
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

                  if (widget.attendanceRecords!.entries.any((element) =>
                      element.value.date.toString().substring(0, 10) ==
                      _date.toString().substring(0, 10))) {
                    var bufferStudentIDList = widget.attendanceRecords!.entries
                        .firstWhere((element) =>
                            element.value.date.toString().substring(0, 10) ==
                            value.toString().substring(0, 10))
                        .value
                        .studentAttendanceCheckboxes
                        .keys
                        .toList();
                    _studentIDs = bufferStudentIDList;
                    var attendanceRecord = widget.attendanceRecords!.values
                        .where((element) =>
                            element.date.toString().substring(0, 10) ==
                            value.toString().substring(0, 10))
                        .first;
                    var attendanceRecordFirebaseDocId = widget
                        .attendanceRecords!.entries
                        .firstWhere(
                          (entry) =>
                              entry.value.date.toString().substring(0, 10) ==
                              value.toString().substring(0, 10),
                        )
                        .key;

                    context.read<AppCubit>().updateState(context
                        .read<AppCubit>()
                        .state
                        .copyWith(
                            currentAttendanceRecord: attendanceRecord,
                            currentAttendanceRecordFirebaseDocId:
                                attendanceRecordFirebaseDocId));
                  } else {
                    _date = value;

                    widget.attendanceRecords!.entries.forEach((element) {});

                    _studentIDs = context
                        .read<AppCubit>()
                        .state
                        .currentBusRoute
                        .studentsIDs;
                    var studentAttendanceCheckboxes =
                        new Map<String, dynamic>();
                    _studentIDs!.forEach((element) {
                      studentAttendanceCheckboxes[element] = false;
                    });
                    var newAttendanceRecord = AttendanceRecordModel(
                        schoolName:
                            context.read<AppCubit>().state.currentSchool.name,
                        busRouteNumber: context
                            .read<AppCubit>()
                            .state
                            .currentBusRoute
                            .busRouteNumber
                            .toString(),
                        studentAttendanceCheckboxes:
                            studentAttendanceCheckboxes,
                        date: value);

                    var oldState = context.read<AppCubit>().state;
                    var newState = oldState.copyWith(
                        currentAttendanceRecord: newAttendanceRecord);
                    context.read<AppCubit>().updateState(newState);
                    newAttendanceRecord
                        .addAttendanceRecordToFirestore()
                        .then((value) {
                      var newState = oldState.copyWith(
                          currentAttendanceRecordFirebaseDocId: value);
                      context.read<AppCubit>().updateState(newState);

                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("students")
                              .where("studentID", whereIn: _studentIDs)
                              .where("schoolName",
                                  isEqualTo: context
                                      .read<AppCubit>()
                                      .state
                                      .currentSchool
                                      .name)
                              .where("busRouteNumber",
                                  isEqualTo: context
                                      .read<AppCubit>()
                                      .state
                                      .currentBusRoute
                                      .busRouteNumber
                                      .toString())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                          });
                    });
                  }
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
