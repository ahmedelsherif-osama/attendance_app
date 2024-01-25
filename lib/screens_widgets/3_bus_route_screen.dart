import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BusRouteScreen extends StatelessWidget {
  BusRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BusRouteModel busRoute = context.read<AppCubit>().state.currentBusRoute;

    String busRouteName =
        'Bus Route ${busRoute.busRouteNumber} for ${busRoute.schoolName}';
    List studentList = busRoute.studentsIDs;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docID = context.read<AppCubit>().state.currentFirebaseDocId;
            try {
              var students = snapshot.data!.docs.where((element) {
                return studentList.contains(element['studentID']);
              }).toList();
              context.read<AppCubit>().updateState(
                    context.read<AppCubit>().state.copyWith(
                          currentBusRoute: busRoute.copyWith(
                            studentsIDs: students
                                .map((e) => e['studentID'].toString())
                                .toList(),
                          ),
                        ),
                  );
              var studentsToModel = students.map((e) {
                return StudentModel(
                  makkani: e['makkani'] ?? 0,
                  latitude: e['latitude'],
                  longtitude: e['longtitude'],
                  group: e['group'],
                  grade: e['grade'],
                  fatherPhoneNumber: e['fatherPhoneNumber'],
                  addressDescription: e['addressDescription'],
                  primaryPhoneNumber: e['primaryPhoneNumber'],
                  name: e['name'],
                  studentID: e['studentID'],
                  busRouteNumber: e['busRouteNumber'],
                  schoolName: e['schoolName'],
                );
              }).toList();
              return BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bus Route ',
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).size.height +
                                      MediaQuery.of(context).size.width) /
                                  100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${busRoute.busRouteNumber}',
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) /
                                    100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            ' for ',
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).size.height +
                                      MediaQuery.of(context).size.width) /
                                  100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${busRoute.schoolName}',
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) /
                                    100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Areas covered: "),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: busRoute.areas.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    busRoute.areas[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                          students: studentsToModel,
                                          currentBusRoute: busRoute,
                                          currentSchool: context
                                              .read<AppCubit>()
                                              .state
                                              .schools
                                              .firstWhere(
                                                (element) =>
                                                    element.name ==
                                                    busRoute.schoolName,
                                              ),
                                        ),
                                  );
                              context.go('/attendance_record');
                              print("what now?");
                            },
                            child: const Text('Take/Check Attendance'),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          ElevatedButton(
                            onPressed: () {
                              context.go('/add_student_screen');
                            },
                            child: const Text("Add Student"),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('busRoutes')
                                  .doc(docID)
                                  .delete();
                              context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                          currentSchool: context
                                              .read<AppCubit>()
                                              .state
                                              .currentSchool
                                              .copyWith(
                                                routesNames: context
                                                    .read<AppCubit>()
                                                    .state
                                                    .currentSchool
                                                    .routesNames
                                                    .where((element) =>
                                                        element !=
                                                        busRoute.busRouteNumber
                                                            .toString())
                                                    .toList(),
                                              ),
                                          currentBusRoute:
                                              BusRouteModel.empty(),
                                        ),
                                  );

                              print("bloody doc id: " +
                                  context
                                      .read<AppCubit>()
                                      .state
                                      .currentSchoolFirebaseDocId);
                              FirebaseFirestore.instance
                                  .collection('schools')
                                  .doc(context
                                      .read<AppCubit>()
                                      .state
                                      .currentSchoolFirebaseDocId)
                                  .update({
                                "routesNames": FieldValue.arrayRemove([
                                  state.currentBusRoute.busRouteNumber
                                      .toString()
                                ]),
                              });

                              context.go('/school_screen');
                            },
                            child: const Text("Delete Bus Route"),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Expanded(
                        child: ListView.builder(
                          itemCount: context
                              .read<AppCubit>()
                              .state
                              .currentBusRoute
                              .studentsIDs
                              .length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    onTap: () {
                                      context.read<AppCubit>().updateState(
                                            context
                                                .read<AppCubit>()
                                                .state
                                                .copyWith(
                                                  currentStudent:
                                                      studentsToModel[index],
                                                ),
                                          );
                                      context.go('/student_details_screen');
                                    },
                                    title: Text(students
                                        .where((element) =>
                                            element['studentID'] ==
                                            context
                                                .read<AppCubit>()
                                                .state
                                                .currentBusRoute
                                                .studentsIDs[index])
                                        .first['name']),
                                    subtitle: Text(
                                      context
                                          .read<AppCubit>()
                                          .state
                                          .currentBusRoute
                                          .studentsIDs[index]
                                          .toString(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.1),
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('busRoutes')
                                        .doc(docID)
                                        .update({
                                      "studentsIDs": FieldValue.arrayRemove(
                                          [students[index]['studentID']])
                                    });
                                    context.read<AppCubit>().updateState(context
                                        .read<AppCubit>()
                                        .state
                                        .copyWith(
                                          currentBusRoute: busRoute.copyWith(
                                            studentsIDs: busRoute.studentsIDs
                                                .where((element) =>
                                                    element !=
                                                    students[index]
                                                        ['studentID'])
                                                .toList(),
                                          ),
                                        ));
                                  },
                                  child: Text('Delete Student'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                    ],
                  );
                },
              );
            } catch (e) {
              print(e);
              return Text("Error");
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
