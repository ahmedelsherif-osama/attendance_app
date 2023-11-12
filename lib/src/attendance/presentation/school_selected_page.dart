import 'package:attendance/core/utils/temp_dummy_data.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:attendance/src/attendance/presentation/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolSelectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Take Attendance"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 300,
                ),
                Center(
                    child: DropdownButton(
                  hint: Text(
                      context.read<AttendanceCubit>().state.school!.schoolName),
                  items: schoolList.map((school) {
                    return DropdownMenuItem<School>(
                      value: school,
                      child: Text(school.schoolName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    context.read<AttendanceCubit>().updateAttendance(
                        school: newValue as School, busRoute: BusRoute.empty());
                    context
                        .read<AttendanceCubit>()
                        .updateAttendance(busRouteList: newValue?.busRoutes);
                  },
                )),
                SizedBox(width: 15),
                Center(
                  child: DropdownButton(
                    hint: const Text("Select Bus Route"),
                    items: context
                        .read<AttendanceCubit>()
                        .state
                        .busRouteList
                        ?.map((busRouteList) {
                      return DropdownMenuItem<BusRoute>(
                        value: busRouteList,
                        child: Text(
                            "Route ${busRouteList.routeNumber.toString()}"),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      context
                          .read<AttendanceCubit>()
                          .updateAttendance(busRoute: newValue as BusRoute?);
                      context
                          .read<AttendanceCubit>()
                          .updateAttendance(studentList: newValue?.students);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
