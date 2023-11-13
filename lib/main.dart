import 'package:attendance/core/utils/router.dart';
import 'package:attendance/src/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubit(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
