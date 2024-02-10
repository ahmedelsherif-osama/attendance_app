import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/firebase_options.dart';
import 'package:final_rta_attendance/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/screens_widgets/2_school_screen.dart';
import 'package:final_rta_attendance/screens_widgets/3_bus_route_screen.dart';
import 'package:final_rta_attendance/screens_widgets/4_attendance_record_screen.dart';
import 'package:final_rta_attendance/screens_widgets/5_student_details_screen.dart';
import 'package:final_rta_attendance/screens_widgets/6_add_school_screen.dart';
import 'package:final_rta_attendance/screens_widgets/7_add_bus_route_screen.dart';
import 'package:final_rta_attendance/screens_widgets/8_add_student_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (_) => AppCubit(
        AppState.empty(),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SchoolList(),
        '/school_screen': (context) => SchoolScreen(),
        '/bus_route_screen': (context) => BusRouteScreen(),
        '/attendance_record_screen': (context) => AttendanceRecordScreen(),
        '/student_details_screen': (context) => StudentDetailsScreen(),
        '/add_school_screen': (context) => AddSchoolScreen(),
        '/add_bus_route_screen': (context) => AddBusRouteScreen(),
        '/add_student_screen': (context) => AddStudentScreen(),
      },
    );
  }
}
