import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
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
            try {
              var students = snapshot.data!.docs.where((element) {
                return studentList.contains(element['studentID']);
              }).toList();
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
              return Column(
                children: [
                  Text(
                    busRouteName,
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height +
                              MediaQuery.of(context).size.width) /
                          100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Areas covered: "),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.1),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextButton(
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
                                            element.name == busRoute.schoolName,
                                      ),
                                ),
                          );
                      context.go('/attendance_record');
                      print("what now?");
                    },
                    child: const Text('Take/Check Attendance'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            context.read<AppCubit>().updateState(
                                  context.read<AppCubit>().state.copyWith(
                                        currentStudent: studentsToModel[index],
                                      ),
                                );
                            context.go('/student_details_screen');
                          },
                          title: Text(students[index]['name']),
                          subtitle: Text(
                            students[index]['studentID'].toString(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
