import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/main.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/no_attendance_records_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordsWidget extends StatelessWidget {
  AttendanceRecordsWidget(
      {required this.attendanceRecords, required this.todaysDate, super.key});
  final Map attendanceRecords;
  final DateTime todaysDate;

  Future<List<StudentModel>> fetchStudentsWithIds(
      String schoolName, int busRouteNumber, studentIds) async {
    List<StudentModel> students = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
          .where("studentID", whereIn: studentIds)
          .get();

      students = querySnapshot.docs
          .map((doc) => StudentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching students: $e");
    }
    print(students.first.name);
    return students;
  }

  @override
  Widget build(BuildContext context) {
    final currentAttendanceRecord =
        context.read<AppCubit>().state.currentAttendanceRecord;
    final attendanceCheckBoxes =
        currentAttendanceRecord.studentAttendanceCheckboxes;
    final height = MediaQuery.of(context).size.height;
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    final studentIds = currentAttendanceRecord.studentAttendanceCheckboxes.keys;

    //fetch the existing attendance records
    // no need passed down from previous widget

    //check if they have one for today
    final todaysAttendanceRecord = attendanceRecords.keys.firstWhere(
      (element) =>
          element.date.toString().substring(0, 10) ==
          todaysDate.toString().substring(0, 10),
      orElse: () => AttendanceRecordModel.empty(),
    );

    if (todaysAttendanceRecord.busRouteNumber == "") {
      // no
      var currentBusRouteNumber = context
          .read<AppCubit>()
          .state
          .currentBusRoute
          .busRouteNumber
          .toString();
      var currentBusStudentIds =
          context.read<AppCubit>().state.currentBusRoute.studentsIDs;
      var studentAttendanceCheckboxes = new Map<String, dynamic>();
      currentBusStudentIds.forEach((element) {
        studentAttendanceCheckboxes[element] = false;
      });
      print(studentAttendanceCheckboxes.entries);

      // create a new record for today itself
      var newAttendanceRecordToday = AttendanceRecordModel(
          schoolName: schoolName,
          busRouteNumber: currentBusRouteNumber,
          studentAttendanceCheckboxes: studentAttendanceCheckboxes,
          date: todaysDate);

      // 1. check if oldest record is older than or equal 30 days old
      var minDate = todaysDate.subtract(const Duration(days: 30));
      for (int index = 0; index < attendanceRecords.length; index++) {
        if (attendanceRecords[index].date.isBefore(minDate)) {
          minDate = attendanceRecords[index].date;
        }
      }

      // a. yes
      // create the dates dropdown menu, all dates starting oldest date
      // b. no
      // create the date dropdown meny, all dates starting 30 days old

      final datesDropDownMenuEntries = List.generate(
          31,
          (index) => DropdownMenuEntry(
              value: minDate.add(Duration(days: index)),
              label: minDate
                  .add(Duration(days: index))
                  .toString()
                  .substring(0, 10)));

      return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              DropdownMenu(
                dropdownMenuEntries: datesDropDownMenuEntries,
                onSelected: (value) {},
              ),
              SizedBox(
                height: height * 0.1,
              ),
              // StudentListWithCheckBoxesWidget(
              //     students: students, attendanceCheckBoxes: studentsCheckBoxes),
              SizedBox(
                height: height * 0.1,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"))
            ],
          ),
        ),
      );

      // display that record
      return Text("still making it");
      // make the rest reachable from dropdown of last 30 days
      //or oldest record of older than 30 days
    } else {
      //yes
      //make the rest reachable from dropdown of last 30 days
      //or oldest record of older than 30 days

      // 1. check if oldest record is older than or equal 30 days old
      var minDate = todaysDate.subtract(const Duration(days: 30));
      for (int index = 0; index < attendanceRecords.length; index++) {
        if (attendanceRecords[index].date.isBefore(minDate)) {
          minDate = attendanceRecords[index].date;
        }
      }

      // a. yes
      // create the dates dropdown menu, all dates starting oldest date
      // b. no
      // create the date dropdown meny, all dates starting 30 days old

      final datesDropDownMenuEntries = List.generate(
          31,
          (index) => DropdownMenuEntry(
              value: minDate.add(Duration(days: index)),
              label: minDate
                  .add(Duration(days: index))
                  .toString()
                  .substring(0, 10)));
      return FutureBuilder(
          future: fetchStudentsWithIds(schoolName, busRouteNumber, studentIds),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final students = snapshot.data as List<StudentModel>;
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      DropdownMenu(
                        dropdownMenuEntries: datesDropDownMenuEntries,
                        onSelected: (value) {
                          final currentAttendanceRecord =
                              attendanceRecords.values.firstWhere((element) =>
                                  element.date.toString().substring(0, 10) ==
                                  value.toString().substring(0, 10));
                          final currentAttendanceRecordDocId =
                              attendanceRecords.keys.firstWhere((element) =>
                                  element.date.toString().substring(0, 10) ==
                                  value.toString().substring(0, 10));
                          // update currentattendance record on state
                          // update current attendance record doc id on state
                          final oldState = context.read<AppCubit>().state;
                          final newState = oldState.copyWith(
                              currentAttendanceRecord: currentAttendanceRecord,
                              currentAttendanceRecordFirebaseDocId:
                                  currentAttendanceRecordDocId);
                          context.read<AppCubit>().updateState(newState);
                        },
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      StudentListWithCheckBoxesWidget(
                          students: students,
                          attendanceCheckBoxes: attendanceCheckBoxes),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Save")),
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          });
      //display one for today first,
    }
  }
}