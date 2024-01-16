import 'package:final_rta_attendance/screens_widgets/4_attendance_record_screen.dart';
import 'package:final_rta_attendance/screens_widgets/3_bus_route_screen.dart';
import 'package:final_rta_attendance/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/screens_widgets/2_school_screen.dart';
import 'package:final_rta_attendance/screens_widgets/5_student_details_screen.dart';
import 'package:final_rta_attendance/screens_widgets/6_add_school_screen.dart';
import 'package:final_rta_attendance/screens_widgets/7_add_bus_route_screen.dart';
import 'package:final_rta_attendance/screens_widgets/8_add_student_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SchoolList(),
    ),
    GoRoute(
      path: '/school_screen',
      builder: (context, state) => SchoolScreen(),
    ),
    GoRoute(
      path: '/attendance_record',
      builder: (context, state) => AttendanceRecordScreen(),
    ),
    GoRoute(
      path: '/bus_route_screen',
      builder: (context, state) => BusRouteScreen(),
    ),
    GoRoute(
      path: '/student_details_screen',
      builder: (context, state) => StudentDetailsScreen(),
    ),
    GoRoute(
      path: '/add_school_screen',
      builder: (context, state) => AddSchoolScreen(),
    ),
    GoRoute(
      path: '/add_bus_route_screen',
      builder: (context, state) => AddBusRouteScreen(),
    ),
    GoRoute(
      path: '/add_student_screen',
      builder: (context, state) => AddStudentScreen(),
    ),
  ],
);
