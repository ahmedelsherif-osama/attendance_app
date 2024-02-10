import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsScreen extends StatelessWidget {
  StudentDetailsScreen({Key? key}) : super(key: key);
  final route = MaterialPageRoute(builder: (context) => StudentDetailsScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(context.read<AppCubit>().state.currentStudent.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              initialValue: context.read<AppCubit>().state.currentStudent.name,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Student ID',
              ),
              initialValue:
                  context.read<AppCubit>().state.currentStudent.studentID,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Primary Phone Number',
              ),
              initialValue: context
                  .read<AppCubit>()
                  .state
                  .currentStudent
                  .primaryPhoneNumber
                  .toString(),
            ),
          ],
        ),
      ),
    );
  }
}
