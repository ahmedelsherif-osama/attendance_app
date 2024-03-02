import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListWithCheckBoxesWidget extends StatefulWidget {
  const StudentListWithCheckBoxesWidget({
    required this.students,
    required this.attendanceCheckBoxes,
    super.key,
  });

  final List<StudentModel> students;
  final Map<String, dynamic> attendanceCheckBoxes;

  @override
  State<StudentListWithCheckBoxesWidget> createState() =>
      _StudentListWithCheckBoxesWidgetState();
}

class _StudentListWithCheckBoxesWidgetState
    extends State<StudentListWithCheckBoxesWidget> {
  @override
  var _attendanceCheckBoxes;
  var _students;
  void initState() {
    super.initState();
    setState(
      () {
        _students = widget.students;
        _attendanceCheckBoxes = widget.attendanceCheckBoxes;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: height * 0.4),
      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.1,
                      child: const Text("ID"),
                    ),
                    Container(
                      width: width * 0.2,
                      child: const Text("Name"),
                    ),
                    Container(
                      width: width * 0.2,
                      child: const Text("Phone"),
                    ),
                    Container(
                      width: width * 0.2,
                      child: const Text("Father's Phone"),
                    ),
                    Container(
                      width: width * 0.2,
                      child: const Text("Attendance"),
                    ),
                  ],
                ),
                for (int index = 0; index < widget.students.length; index++)
                  Row(
                    children: [
                      Container(
                        width: width * 0.1,
                        child: Text(widget.students[index].studentID),
                      ),
                      Container(
                        width: width * 0.2,
                        child: Text(widget.students[index].name),
                      ),
                      Container(
                        width: width * 0.2,
                        child: Text(widget.students[index].primaryPhoneNumber
                            .toString()),
                      ),
                      Container(
                        width: width * 0.2,
                        child: Text(widget.students[index].fatherPhoneNumber
                            .toString()),
                      ),
                      Container(
                        width: width * 0.2,
                        child: Checkbox(
                          value: _attendanceCheckBoxes[
                              _students[index].studentID.toString()],
                          onChanged: (value) {
                            setState(() {
                              _attendanceCheckBoxes[_students[index]
                                  .studentID
                                  .toString()] = value;
                            });
                            final schoolName = context
                                .read<AppCubit>()
                                .state
                                .currentSchool
                                .name;
                            final busRouteNumber = context
                                .read<AppCubit>()
                                .state
                                .currentBusRoute
                                .busRouteNumber
                                .toString();
                            final attendanceRecordDocId = context
                                .read<AppCubit>()
                                .state
                                .currentAttendanceRecordFirebaseDocId;

                            final attendanceRecord = context
                                .read<AppCubit>()
                                .state
                                .currentAttendanceRecord;
                            final newAttendanceRecord =
                                attendanceRecord.copyWith(
                                    studentAttendanceCheckboxes:
                                        _attendanceCheckBoxes);
                            final oldState = context.read<AppCubit>().state;
                            final newState = oldState.copyWith(
                                currentAttendanceRecord: newAttendanceRecord);
                            context.read<AppCubit>().updateState(newState);
                            newAttendanceRecord
                                .updateAttendanceRecordOnFirestore(
                                    attendanceRecordDocId);
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
