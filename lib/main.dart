import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_app/cubit/app_cubit.dart';
import 'package:attendance_app/cubit/app_state.dart';
import 'package:attendance_app/firebase_options.dart';
import 'package:attendance_app/models/3_student_model.dart';
import 'package:attendance_app/presentation/screens_widgets/1_school_list.dart';
import 'package:attendance_app/presentation/screens_widgets/2_school_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/3_bus_route_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/5_student_details_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/6_add_school_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/7_add_bus_route_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/9_attendance_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

Future<List<StudentModel>> fetchStudents(
    String schoolName, int busRouteNumber) async {
  List<StudentModel> students = [];

  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where("schoolName", isEqualTo: schoolName)
        .where("busRouteNumber", isEqualTo: busRouteNumber)
        .get();

    students = querySnapshot.docs
        .map((doc) => StudentModel.fromJson(doc.data()))
        .toList();
  } catch (e) {
    print("Error fetching students: $e");
  }

  return students;
}

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
        '/': (context) => SchoolListScreen(),
        '/school_screen': (context) => SchoolScreen(),
        '/bus_route_screen': (context) => BusRouteScreen(),
        '/attendance_record_screen': (context) => AttendanceScreen(),
        '/student_details_screen': (context) => StudentDetailsScreen(),
        '/add_school_screen': (context) => AddSchoolScreen(),
        '/add_bus_route_screen': (context) => AddBusRouteScreen(),
        '/add_student_screen': (context) => AddStudentScreen(),
      },
    );
  }
}
