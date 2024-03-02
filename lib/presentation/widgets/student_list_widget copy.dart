import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/5_student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListWithCheckBoxesWidget extends StatelessWidget {
  const StudentListWithCheckBoxesWidget(
      {required this.students, required this.attendanceCheckBoxes, super.key});
  final List<StudentModel> students;
  final Map<String, dynamic> attendanceCheckBoxes;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                children: [
                  const Text("ID"),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  const Text("Name"),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  const Text("Phone"),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  const Text("Father's Phone"),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  const Text("Attendance"),
                ],
              ),
              for (int index = 0; index < students.length; index++)
                Row(
                  children: [
                    Text(students[index].studentID),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(students[index].name),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(students[index].primaryPhoneNumber.toString()),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(students[index].fatherPhoneNumber.toString()),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Checkbox(
                      value: attendanceCheckBoxes[
                          students[index].studentID.toString()],
                      onChanged: (value) {},
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
