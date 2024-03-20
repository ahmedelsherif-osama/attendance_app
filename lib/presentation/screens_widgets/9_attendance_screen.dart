import 'package:final_rta_attendance/presentation/widgets/attendance_records_widget_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/4_attendance_record_model.dart';
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
            .where("busRouteNumber", isEqualTo: busRouteNumber.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}"); // Show error message
          } else {
            final attendanceRecords = snapshot.data;

            if (attendanceRecords!.docs.isEmpty) {
              print("No attendance records found");
              return Text("no attendance records");
            } else {
              print("Attendance records found");
              var attendanceRecordsBufferMap =
                  new Map<String, AttendanceRecordModel>();
              print("empty map");
              print(attendanceRecords.docs.isEmpty);
              attendanceRecords.docs.forEach(
                (element) {
                  attendanceRecordsBufferMap[element.id] =
                      AttendanceRecordModel(
                    schoolName: element["schoolName"],
                    busRouteNumber: element["busRouteNumber"],
                    studentAttendanceCheckboxes:
                        element["studentAttendanceCheckboxes"],
                    date: element["date"].toDate(),
                  );
                  print("right before the widget");
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
