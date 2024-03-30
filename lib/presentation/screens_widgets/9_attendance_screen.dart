import 'package:attendance_app/presentation/widgets/attendance_records_widget_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_app/cubit/app_cubit.dart';
import 'package:attendance_app/models/4_attendance_record_model.dart';
import 'package:attendance_app/presentation/widgets/no_students_widget.dart';

class AttendanceScreen extends StatelessWidget {
  final todaysDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    final busRouteNumber =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    final studentIds =
        context.read<AppCubit>().state.currentBusRoute.studentsIDs;

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
              var studentAttendanceCheckboxes = new Map<String, dynamic>();
              studentIds.forEach((element) {
                studentAttendanceCheckboxes[element] = false;
              });
              var newAttendanceRecord = AttendanceRecordModel(
                  schoolName: schoolName,
                  busRouteNumber: busRouteNumber.toString(),
                  studentAttendanceCheckboxes: studentAttendanceCheckboxes,
                  date: todaysDate);
              var attendanceRecords = new Map<String, AttendanceRecordModel>();

              return FutureBuilder<String?>(
                future: newAttendanceRecord.addAttendanceRecordToFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final value = snapshot.data;
                    attendanceRecords[value!] = newAttendanceRecord;
                    var oldState = context.read<AppCubit>().state;
                    var newState = oldState.copyWith(
                      currentAttendanceRecord: newAttendanceRecord,
                      currentAttendanceRecordFirebaseDocId: value,
                    );
                    context.read<AppCubit>().updateState(newState);

                    return AttendanceRecordsWidget(
                      attendanceRecords: attendanceRecords,
                      todaysDate: todaysDate,
                    );
                  } else {
                    return CircularProgressIndicator(); // Or any loading indicator
                  }
                },
              );
            } else {
              var attendanceRecordsBufferMap =
                  new Map<String, AttendanceRecordModel>();

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
