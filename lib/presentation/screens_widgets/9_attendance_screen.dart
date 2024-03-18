import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
import 'package:final_rta_attendance/presentation/widgets/no_attendance_records_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/attendance_records_widget.dart';
import 'package:final_rta_attendance/presentation/widgets/no_students_widget.dart';

class AttendanceScreen extends StatelessWidget {
  final todaysDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    final studentIds =
        context.read<AppCubit>().state.currentBusRoute.studentsIDs;

    print("${busRouteNumber}   ${studentIds}");

    if (studentIds.isEmpty || studentIds == []) {
      return NoStudentsWidget();
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("attendanceRecords")
            .where("schoolName", isEqualTo: schoolName)
            .where("busRouteNumber", isEqualTo: busRouteNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}"); // Show error message
          } else {
            final attendanceRecords = snapshot.data;

            if (attendanceRecords == null) {
              print("No attendance records found");
              return NoAttendanceRecordsWidget(todaysDate: todaysDate);
            } else {
              print("Attendance records found");
              var attendanceRecordsBufferMap = new Map<dynamic, dynamic>();
              attendanceRecords.docs.forEach(
                (element) {
                  attendanceRecordsBufferMap[element.id] =
                      AttendanceRecordModel.fromJson(
                          element.data() as Map<String, dynamic>);
                },
              );
              return AttendanceRecordsWidget(
                attendanceRecords: attendanceRecordsBufferMap,
                todaysDate: todaysDate,
              );
            }
          }
        },
      );
    }
  }
}
