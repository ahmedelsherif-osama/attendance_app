import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendace_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordScreen extends StatefulWidget {
  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  DateTime? _date;
  List<StudentModel> _students = [];
  List<bool> _attendanceCheckboxes = [];

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

  Future<List> fetchAttendanceRecordsAndStudents(
      String schoolName, int busRouteNumber) async {
    List<AttendanceRecordModel> attendanceRecords = [];
    List<String> attendanceRecordsDocIds = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("attendanceRecords")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
          .get();

      attendanceRecords = querySnapshot.docs
          .map(
            (doc) => AttendanceRecordModel(
                date: doc.data()['date'].toDate() as DateTime,
                busRouteNumber: doc.data()['busRouteNumber'],
                schoolName: doc.data()['schoolName'],
                studentAttendanceCheckboxes: Map<String, bool>.from(
                    doc.data()['studentAttendanceCheckboxes'])),
          )
          .toList();
      attendanceRecordsDocIds =
          querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching attendanceRecords: $e");
    }
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
    print(attendanceRecords.first.date);
    return [attendanceRecords, students, attendanceRecordsDocIds];
  }

  @override
  Widget build(BuildContext context) {
    final studentsFromBusRouteFromState =
        context.read<AppCubit>().state.currentBusRoute.studentsIDs;
    final schoolName =
        context.read<AppCubit>().state.currentBusRoute.schoolName;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (studentsFromBusRouteFromState.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * .4,
              ),
              Text("No students in bus route yet."),
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

    //if busroutes has students already
    // 1. fetch attendance records from DB, for this school/busroutes number
    // 1.2 if no records yet, create a record with todays date, and still display the calendar

    // 1.5 have a calendar with records dates, upon selection the record from the date will show, if empty will create new record
    // 1.7 on the calendar, if record exists on date, it will show as highlighted or blue
    // 1.8 limit the calendar for crrent or previous dates
    // 2. check if there is a record with today's date for this school and busroute number
    // 3. if it exists already, then display that record, with edit options there
    // 4. if not, then create a new record on state where all students are still absent
    // 5. upon pressing submit, if the record is new, create a new doc on db
    // 6. upon pressing submit, if the record exists already, update the doc on db with new values

    return FutureBuilder(
      future: fetchAttendanceRecordsAndStudents(schoolName, busRouteNumber),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final attendanceRecords =
              snapshot.data![0].cast<AttendanceRecordModel>();
          var students = snapshot.data![1].cast<StudentModel>();

          final dates = snapshot.data![0].map((e) => e.date).toList();
          final datesDropdownMenuEntries = List.generate(
              dates.length,
              (index) => DropdownMenuEntry(
                  value: attendanceRecords[index],
                  label: dates[index].toString()));
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  DropdownMenu(
                    dropdownMenuEntries: datesDropdownMenuEntries,
                    onSelected: (value) {
                      setState(() {
                        _date = value.date;
                        _attendanceCheckboxes =
                            value.studentAttendanceCheckboxes.values.toList();
                        _students = students;
                        // _students.removeWhere((element) => !value
                        //     .studentAttendanceCheckboxes.keys
                        //     .contains(element.studentID));
                      });
                    },
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  StudentListWidget(
                      students: _students,
                      attendanceCheckBoxes: _attendanceCheckboxes)
                ],
              ),
            ),
          );
        } else {
          return FutureBuilder(
            future: fetchStudents(schoolName, busRouteNumber),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final students = snapshot.data;
                print("fetched students");

                return Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.7,
                        ),
                        SizedBox(
                          height: height * 0.7,
                        ),
                        StudentListWidget(
                            students: students!,
                            attendanceCheckBoxes: List.generate(
                                students.length, (index) => false))
                      ],
                    ),
                  ),
                );
              } else {
                print("${schoolName} ${busRouteNumber}");
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.3,
                      ),
                      Text("no students habibi"),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
