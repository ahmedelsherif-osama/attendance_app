import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentsFromBusRouteFromState =
        context.read<AppCubit>().state.currentBusRoute.studentsIDs;
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
    // 1.5 have a calendar with records dates, upon selection the record from the date will show, if empty will create new record
    // 1.7 on the calendar, if record exists on date, it will show as highlighted or blue
    // 1.8 limit the calendar for crrent or previous dates
    // 2. check if there is a record with today's date for this school and busroute number
    // 3. if it exists already, then display that record, with edit options there
    // 4. if not, then create a new record on state where all students are still absent
    // 5. upon pressing submit, if the record is new, create a new doc on db
    // 6. upon pressing submit, if the record exists already, update the doc on db with new values
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            const Text("student1"),
            const Text("student2"),
            const Text("student3"),
            const Text("student4"),
            const Text("student5"),
          ],
        ),
      ),
    );
  }
}
