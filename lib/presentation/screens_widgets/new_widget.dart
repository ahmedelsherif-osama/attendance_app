import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:final_rta_attendance/presentation/widgets/attendance_records_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/no_attendance_records_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/no_students_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/student_list_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewWidget extends StatelessWidget {
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

  Future<Map> fetchAttendanceRecordsWithDocIds(
      String schoolName, int busRouteNumber) async {
    Map attendanceRecords = new Map();

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("attendanceRecords")
          .where("schoolName", isEqualTo: schoolName)
          .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
          .get();

      attendanceRecords = querySnapshot.docs.map(
        (doc) => {
          doc.id: AttendanceRecordModel(
            busRouteNumber: doc.data()['busRouteNumber'],
            schoolName: doc.data()['schoolName'],
            date: doc.data()['date'].toDate(),
            studentAttendanceCheckboxes:
                doc.data()['studentAttendanceCheckboxes'],
          )
        },
      ) as Map;
    } catch (e) {
      print("Error fetching attendanceRecords: $e");
    }
    return attendanceRecords;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    final studentIds =
        context.read<AppCubit>().state.currentBusRoute.studentsIDs;

    if (studentIds.isEmpty || studentIds == []) {
      return NoStudentsWidget();
    } else {
      return FutureBuilder(
        future: fetchAttendanceRecordsWithDocIds(schoolName, busRouteNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AttendanceRecordsWidget(
                attendanceRecords: snapshot.data as Map,
                todaysDate: todaysDate);
          } else {
            // return Text("we dont have attendance records");
            //if no attendance records, create one for today
            //display dates for 30 previous days as well, so user can create for them as well

            return NoAttendanceRecordsWidget(todaysDate: todaysDate);
          }
        },
      );
    }
  }
}
