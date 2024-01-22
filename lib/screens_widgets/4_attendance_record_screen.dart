import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/4_attendace_record_model.dart';
import 'package:final_rta_attendance/screens_widgets/student_list_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceRecordScreen extends StatefulWidget {
  AttendanceRecordScreen({Key? key}) : super(key: key);
  var mappedData2;

  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. create date format
    final dateFormat = DateFormat('dd/MM/yyyy');
    // 2. get the date from the state

    final date = dateFormat.format(context.read<AppCubit>().state.currentDate);
    // 3. get the bus route number from the state
    final busRoute =
        context.read<AppCubit>().state.currentBusRoute.busRouteNumber;
    // 4. get the school name from the state
    final schoolName = context.read<AppCubit>().state.currentSchool.name;
    // 5. get the students from the state
    final students = context.read<AppCubit>().state.students;
    print("students: $students busRoute: $busRoute schoolName: $schoolName");
    // 6. get the attendance records from the database, for this school and bus route
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.9,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('attendanceRecords')
              .where('busRouteNumber', isEqualTo: busRoute)
              .where('schoolName', isEqualTo: schoolName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // 7. check if there is a document for state's date
              try {
                print("what");
                print(date);
                print("finished");

                var statesDateDoc = snapshot.data!.docs.firstWhere((element) =>
                    dateFormat.format(element['date'].toDate()) == date);

                context
                    .read<AppCubit>()
                    .updateState(context.read<AppCubit>().state.copyWith(
                          currentFirebaseDocId: statesDateDoc.id,
                        ));

                var mappedData2 = statesDateDoc['studentAttendanceCheckboxes']
                    .map((key, value) {
                  debugPrint('key: $key value: $value');
                  return MapEntry(key, value);
                });

                //here do what we were doing before    return Column(
                return BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: snapshot.data!.docs.map((e) {
                                return DropdownMenuItem(
                                  child: Text(
                                      dateFormat.format(e['date'].toDate())),
                                  value: dateFormat.format(e['date'].toDate()),
                                );
                              }).toList(),
                              value: dateFormat.format(
                                  context.read<AppCubit>().state.currentDate),
                              onChanged: (value) {
                                context.read<AppCubit>().updateState(
                                      context.read<AppCubit>().state.copyWith(
                                            currentDate: DateTime(
                                              dateFormat
                                                  .parse(value.toString())
                                                  .year,
                                              dateFormat
                                                  .parse(value.toString())
                                                  .month,
                                              dateFormat
                                                  .parse(value.toString())
                                                  .day,
                                            ),
                                          ),
                                    );
                                statesDateDoc = snapshot.data!.docs.firstWhere(
                                    (element) =>
                                        dateFormat
                                            .format(element['date'].toDate()) ==
                                        dateFormat.format(context
                                            .read<AppCubit>()
                                            .state
                                            .currentDate));
                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                          currentFirebaseDocId:
                                              statesDateDoc.id,
                                        ));
                                mappedData2 = statesDateDoc[
                                    'studentAttendanceCheckboxes'];
                                setState(() {
                                  mappedData2 = statesDateDoc[
                                          'studentAttendanceCheckboxes']
                                      .map((key, value) {
                                    debugPrint('key: $key value: $value');
                                    return MapEntry(key, value);
                                  });
                                });
                              },
                            ),
                            Text(
                                '${snapshot.data!.docs.firstWhere((element) => dateFormat.format(element['date'].toDate()) == date).data()['schoolName']} - Route ${snapshot.data!.docs.firstWhere((element) => dateFormat.format(element['date'].toDate()) == date).data()['busRouteNumber'].toString()}'),
                          ],
                        ),
                        StudentListWidget(
                          mappedData2: mappedData2,
                          docId: context
                              .read<AppCubit>()
                              .state
                              .currentFirebaseDocId,
                        ),
                      ],
                    );
                  },
                );

                //add a bloody submit button, that sends the new map to the database, updates the existing one for the date
              } catch (e) {
                //here we will create a new document, with todays date, and the bus route number and school name
                var studentsMapFromBusRoute = context
                    .read<AppCubit>()
                    .state
                    .currentBusRoute
                    .studentsIDs
                    .map((e) => MapEntry<String, bool>(e, false));
                context.read<AppCubit>().updateState(
                      context.read<AppCubit>().state.copyWith(
                            currentAttendanceRecord: AttendanceRecordModel(
                              schoolName: context
                                  .read<AppCubit>()
                                  .state
                                  .currentSchool
                                  .name,
                              busRouteNumber: context
                                  .read<AppCubit>()
                                  .state
                                  .currentBusRoute
                                  .busRouteNumber,
                              studentAttendanceCheckboxes:
                                  Map.fromEntries(studentsMapFromBusRoute),
                              date: context.read<AppCubit>().state.currentDate,
                            ),
                          ),
                    );
                context
                    .read<AppCubit>()
                    .state
                    .currentAttendanceRecord
                    .addAttendanceRecordToFirestore();

                var statesDateDoc = snapshot.data!.docs.firstWhere((element) =>
                    dateFormat.format(element['date'].toDate()) == date);

                context
                    .read<AppCubit>()
                    .updateState(context.read<AppCubit>().state.copyWith(
                          currentFirebaseDocId: statesDateDoc.id,
                        ));

                var mappedData2 = statesDateDoc['studentAttendanceCheckboxes']
                    .map((key, value) {
                  debugPrint('key: $key value: $value');
                  return MapEntry(key, value);
                });

                //here do what we were doing before    return Column(
                return BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              items: snapshot.data!.docs.map((e) {
                                return DropdownMenuItem(
                                  child: Text(
                                      dateFormat.format(e['date'].toDate())),
                                  value: dateFormat.format(e['date'].toDate()),
                                );
                              }).toList(),
                              value: dateFormat.format(
                                  context.read<AppCubit>().state.currentDate),
                              onChanged: (value) {
                                context.read<AppCubit>().updateState(
                                      context.read<AppCubit>().state.copyWith(
                                            currentDate: DateTime(
                                              dateFormat
                                                  .parse(value.toString())
                                                  .year,
                                              dateFormat
                                                  .parse(value.toString())
                                                  .month,
                                              dateFormat
                                                  .parse(value.toString())
                                                  .day,
                                            ),
                                          ),
                                    );
                                statesDateDoc = snapshot.data!.docs.firstWhere(
                                    (element) =>
                                        dateFormat
                                            .format(element['date'].toDate()) ==
                                        dateFormat.format(context
                                            .read<AppCubit>()
                                            .state
                                            .currentDate));
                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                          currentFirebaseDocId:
                                              statesDateDoc.id,
                                        ));
                                mappedData2 = statesDateDoc[
                                    'studentAttendanceCheckboxes'];
                                setState(() {
                                  mappedData2 = statesDateDoc[
                                          'studentAttendanceCheckboxes']
                                      .map((key, value) {
                                    debugPrint('key: $key value: $value');
                                    return MapEntry(key, value);
                                  });
                                });
                              },
                            ),
                            Text(
                                '${snapshot.data!.docs.firstWhere((element) => dateFormat.format(element['date'].toDate()) == date).data()['schoolName']} - Route ${snapshot.data!.docs.firstWhere((element) => dateFormat.format(element['date'].toDate()) == date).data()['busRouteNumber'].toString()}'),
                          ],
                        ),
                        StudentListWidget(
                          mappedData2: mappedData2,
                          docId: context
                              .read<AppCubit>()
                              .state
                              .currentFirebaseDocId,
                        ),
                      ],
                    );
                  },
                );

                //and then we will create a map of all the students in the bus route, and set their attendance to false
                //and then we will add this map to the document
                //and then we will do what we were doing before
                //add a bloody submit button, that sends the new map to the database, updates the existing one for the date

                print(e);
                return Text(e.toString());
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          // Remove the extra closing parenthesis
          // );
        ),
      ),
    );
  }
}
