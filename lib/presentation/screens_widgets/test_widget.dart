import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestWidget extends StatelessWidget {
  // this is the new attendance record screen
  TestWidget({super.key});

  final todaysDate = DateTime.now();

  Future<String> fetchAttendanceRecordIdWithSchoolNameBusRouteNumber(
      String schoolName, int busRouteNumber) async {
    late String docId;

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("attendanceRecords")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Use id to get the document ID
        docId = querySnapshot.docs.first.id;
      }
    } catch (e) {
      print("Error fetching attendance record ID: $e");
    }

    return docId;
  }

  Future<List<StudentModel>> fetchStudents(
      String schoolName, int busRouteNumber) async {
    List<StudentModel> students = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
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

  Future<List<AttendanceRecordModel>> fetchAttendanceRecords(
      String schoolName, int busRouteNumber) async {
    List<AttendanceRecordModel> attendanceRecords = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("attendanceRecords")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
          .get();

      attendanceRecords = querySnapshot.docs
          .map((doc) => AttendanceRecordModel(
                busRouteNumber: doc.data()['busRouteNumber'],
                schoolName: doc.data()['schoolName'],
                date: doc.data()['date'].toDate(),
                studentAttendanceCheckboxes:
                    doc.data()['studentAttendanceCheckboxes'],
              ))
          .toList();
    } catch (e) {
      print("Error fetching attendanceRecords: $e");
    }
    print(attendanceRecords.first.date);
    return attendanceRecords;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    return FutureBuilder(
      future: fetchStudents(schoolName, busRouteNumber),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //proceed normally

          //get students from snapshot
          final students = snapshot.data as List<StudentModel>;
          return FutureBuilder(
            future: fetchAttendanceRecords(schoolName, busRouteNumber),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //get attendance records from snapshot
                final attendanceRecords =
                    snapshot.data as List<AttendanceRecordModel>;
                print(attendanceRecords.first.date);
                return Text(attendanceRecords.first.date.toString());
              }
              if (snapshot.hasData == false) {
                //if no attendance records, create one for today
                //display dates for 30 previous days as well, so user can create for them as well
                List<String> studentIds = [];
                students.forEach(
                  (element) {
                    studentIds.add(element.studentID);
                  },
                );

                Map<String, bool> studentsCheckBoxes = Map.fromIterable(
                    studentIds,
                    key: (id) => id,
                    value: (_) => false);
                var datesDropDownEntries = <DropdownMenuEntry>[];
                for (int index = 0; index < 10; index++) {
                  var bufferDate = todaysDate.subtract(Duration(days: index));
                  var bufferItem = DropdownMenuEntry(
                      label: bufferDate.toString().substring(0, 10),
                      value: bufferDate);
                  datesDropDownEntries.add(bufferItem);
                }
                return Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                        ),
                        DropdownMenu(
                          dropdownMenuEntries: datesDropDownEntries,
                          onSelected: (value) {
                            AttendanceRecordModel(
                              schoolName: schoolName,
                              busRouteNumber: busRouteNumber.toString(),
                              studentAttendanceCheckboxes: studentsCheckBoxes,
                              date: value,
                            ).addAttendanceRecordToFirestore();

                            final currentAttendanceRecord =
                                AttendanceRecordModel(
                              schoolName: schoolName,
                              busRouteNumber: busRouteNumber.toString(),
                              studentAttendanceCheckboxes: studentsCheckBoxes,
                              date: value,
                            );

                            fetchAttendanceRecordIdWithSchoolNameBusRouteNumber(
                                    schoolName, busRouteNumber)
                                .then((value) {
                              final oldState = context.read<AppCubit>().state;
                              final newState = oldState.copyWith(
                                currentAttendanceRecordFirebaseDocId: value,
                                currentAttendanceRecord:
                                    currentAttendanceRecord,
                              );
                              context.read<AppCubit>().updateState(newState);
                              final currentAttendanceRecordDocId = context
                                  .read<AppCubit>()
                                  .state
                                  .currentAttendanceRecordFirebaseDocId;
                              print(currentAttendanceRecordDocId);
                            });
                          },
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        StudentListWithCheckBoxesWidget(
                            students: students,
                            attendanceCheckBoxes: studentsCheckBoxes),
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
              }
              return Text("Loading, maybe no existing attendance records");
            },
          );
        }
        if (snapshot.hasData == false) {
          // if no students and no attendance records within this busroute/school combination yet

          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height * .4,
                  ),
                  const CircularProgressIndicator(),
                  Text("Maybe no students in bus route yet."),
                  SizedBox(
                    height: height * .1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/add_student_screen', (route) => false);
                    },
                    child: const Text("Add student"),
                  ),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
