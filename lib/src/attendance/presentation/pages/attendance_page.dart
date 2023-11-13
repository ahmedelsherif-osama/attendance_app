import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:attendance/src/attendance/presentation/pages/bus_route_selected_page.dart';
import 'package:attendance/src/attendance/presentation/pages/initial_page.dart';
import 'package:attendance/src/attendance/presentation/pages/school_selected_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
      if (state.school == School.empty()) {
        return InitialPage();
      }
      if (state.busRoute == BusRoute.empty()) {
        print(state.busRouteList.toString());
        return SchoolSelectedPage();
      }
      return BusRouteSelectedPage();
    });
  }
}
