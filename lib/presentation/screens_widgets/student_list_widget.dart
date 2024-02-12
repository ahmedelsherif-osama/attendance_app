import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/4_attendace_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListWidget extends StatefulWidget {
  StudentListWidget({Key? key, required this.mappedData2, required this.docId})
      : super(key: key);
  var mappedData2;
  var docId;

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: widget.mappedData2.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    children: [
                      Text("this is index" +
                          widget.mappedData2.keys.elementAt(index).toString()),
                      Checkbox(
                        value: widget.mappedData2.values
                                    .elementAt(index)
                                    .toString() ==
                                "true"
                            ? true
                            : false,
                        onChanged: (value) {
                          setState(() {
                            widget.mappedData2.update(
                                widget.mappedData2.keys
                                    .elementAt(index)
                                    .toString(),
                                (value1) => value);
                            print(
                                "mappedData2 update done ${widget.mappedData2}.");
                          });
                          context.read<AppCubit>().updateState(
                                context.read<AppCubit>().state.copyWith(
                                      currentAttendanceRecord:
                                          AttendanceRecordModel(
                                        schoolName: state.currentSchool.name,
                                        busRouteNumber: state
                                            .currentBusRoute.busRouteNumber,
                                        studentAttendanceCheckboxes: widget
                                            .mappedData2
                                            .map<String, bool>((key, value) {
                                          if (key ==
                                              widget.mappedData2.keys
                                                  .elementAt(index)
                                                  .toString())
                                            return MapEntry<String, bool>(
                                              key,
                                              value!,
                                            );
                                          else
                                            return MapEntry<String, bool>(
                                              key,
                                              value,
                                            );
                                        }),
                                        date: state.currentDate,
                                      ),
                                    ),
                              );
                          print(context
                              .read<AppCubit>()
                              .state
                              .currentBusRouteFirebaseDocId);
                          context
                              .read<AppCubit>()
                              .state
                              .currentAttendanceRecord
                              .updateAttendanceRecordOnFirestore(
                                context
                                    .read<AppCubit>()
                                    .state
                                    .currentBusRouteFirebaseDocId,
                              );
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            widget.mappedData2.remove(widget.mappedData2.keys
                                .elementAt(index)
                                .toString());
                            context.read<AppCubit>().updateState(
                                context.read<AppCubit>().state.copyWith(
                                      currentAttendanceRecord:
                                          AttendanceRecordModel(
                                        schoolName: state.currentSchool.name,
                                        busRouteNumber: state
                                            .currentBusRoute.busRouteNumber,
                                        studentAttendanceCheckboxes: widget
                                            .mappedData2
                                            .map<String, bool>((key, value) {
                                          return MapEntry<String, bool>(
                                            key,
                                            value,
                                          );
                                        }),
                                        date: state.currentDate,
                                      ),
                                    ));
                            context
                                .read<AppCubit>()
                                .state
                                .currentAttendanceRecord
                                .updateAttendanceRecordOnFirestore(context
                                    .read<AppCubit>()
                                    .state
                                    .currentBusRouteFirebaseDocId);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
