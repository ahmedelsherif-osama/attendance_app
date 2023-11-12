import 'package:attendance/src/attendance/presentation/attendance_page.dart';
import 'package:attendance/src/attendance/presentation/home_page_view.dart';
import 'package:attendance/src/attendance/presentation/manage_schools_bus_routes_students_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePageView(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => AttendancePage(),
    ),
    GoRoute(
      path: '/manage-all',
      builder: (context, state) => const ManageSchoolsBusRoutesStudentsPage(),
    ),
  ],
);
