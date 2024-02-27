import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/5_student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListWidget extends StatelessWidget {
  const StudentListWidget(
      {required this.students, required this.attendanceCheckBoxes, super.key});
  final List<StudentModel> students;
  final List<bool> attendanceCheckBoxes;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: width * 0.1,
            columns: const [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Grade")),
              DataColumn(label: Text("Group")),
              DataColumn(label: Text("Phone")),
              DataColumn(label: Text("Address")),
            ],
            rows: List<DataRow>.generate(
              students.length,
              (index) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(students[index].studentID.toString()),
                    ),
                    DataCell(
                      Text(students[index].name),
                    ),
                    DataCell(
                      Text(students[index].grade.toString()),
                    ),
                    DataCell(
                      Text(students[index].group.toString()),
                    ),
                    DataCell(
                      Text(students[index].primaryPhoneNumber.toString()),
                    ),
                    DataCell(
                      Text(students[index].addressDescription),
                    ),
                  ],
                  onSelectChanged: (bool? selected) {
                    if (selected != null && selected) {
                      print(
                          "Clicked on student with ID: ${students[index].studentID}");
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
