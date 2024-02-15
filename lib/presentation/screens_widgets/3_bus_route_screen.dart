import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/4_attendance_record_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/5_student_details_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:final_rta_attendance/presentation/widgets/change_details_popup.dart';
import 'package:final_rta_attendance/presentation/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteScreen extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => BusRouteScreen());

  @override
  Widget build(BuildContext context) {
    final BusRouteModel busRoute =
        context.read<AppCubit>().state.currentBusRoute;
    final SchoolModel school = context.read<AppCubit>().state.currentSchool;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.1, horizontal: width * 0.1),
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('students').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var studentCount = snapshot.data!.docs
                    .where((element) =>
                        element['busRouteNumber'].toString() ==
                            busRoute.busRouteNumber.toString() &&
                        element['schoolName'].toString() ==
                            school.name.toString())
                    .length;
                var studentList = snapshot.data!.docs
                    .where((element) =>
                        element['busRouteNumber'].toString() ==
                            busRoute.busRouteNumber.toString() &&
                        element['schoolName'].toString() ==
                            school.name.toString())
                    .toList();

                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.2,
                          child: const Text("Bus Route: "),
                        ),
                        SizedBox(
                          width: width * 0.1,
                          child: Text(
                            busRoute.busRouteNumber.toString(),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: const Text("School: "),
                        ),
                        SizedBox(
                          width: width * 0.3,
                          child: Text(
                            school.name,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: const Text("Students:"),
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
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
                              studentList.length,
                              (index) {
                                var student = studentList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(student['studentID'].toString()),
                                    ),
                                    DataCell(
                                      Text(student['name']),
                                    ),
                                    DataCell(
                                      Text(student['grade'].toString()),
                                    ),
                                    DataCell(
                                      Text(student['group'].toString()),
                                    ),
                                    DataCell(
                                      Text(student['primaryPhoneNumber']
                                          .toString()),
                                    ),
                                    DataCell(
                                      Text(student['addressDescription']),
                                    ),
                                  ],
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      print(
                                          "Clicked on student with ID: ${student['studentID']}");
                                      StudentModel studentModel = StudentModel(
                                        name: student['name'],
                                        studentID: student['studentID'],
                                        primaryPhoneNumber:
                                            student['primaryPhoneNumber'],
                                        fatherPhoneNumber:
                                            student['fatherPhoneNumber'],
                                        grade: student['grade'],
                                        group: student['group'],
                                        longtitude: student['longtitude'],
                                        latitude: student['latitude'],
                                        addressDescription:
                                            student['addressDescription'],
                                        makkani: student['makkani'],
                                        schoolName: student['schoolName'],
                                        busRouteNumber:
                                            student['busRouteNumber'],
                                      );
                                      context.read<AppCubit>().updateState(
                                            context
                                                .read<AppCubit>()
                                                .state
                                                .copyWith(
                                                  currentStudent: studentModel,
                                                  currentStudentFirebaseDocId:
                                                      student.id,
                                                ),
                                          );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StudentDetailsScreen(),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              height: height,
                              width: width,
                              text: "Take Attendance",
                              color: Colors.green,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AttendanceRecordScreen(),
                                  ),
                                );
                              },
                            ),
                            CustomButton(
                              height: height,
                              width: width,
                              color: Colors.blue,
                              text: "Add Student",
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddStudentScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                                height: height,
                                width: width,
                                color: Colors.blue,
                                text: "Change details",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChangeDetailsPopup();
                                    },
                                  );
                                }),
                            CustomButton(
                              height: height,
                              width: width,
                              color: Colors.red,
                              text: "Delete Bus Route",
                              onTap: () {
                                var busRoute = context
                                    .read<AppCubit>()
                                    .state
                                    .currentBusRoute;
                                var busRouteDocId = context
                                    .read<AppCubit>()
                                    .state
                                    .currentBusRouteFirebaseDocId;
                                busRoute
                                    .deleteBusRouteFromFirestore(busRouteDocId);
                                studentList.forEach((element) {
                                  if (element['busRouteNumber'].toString() ==
                                      busRoute.busRouteNumber.toString()) {
                                    print(element.id);
                                    FirebaseFirestore.instance
                                        .collection("students")
                                        .doc(element.id)
                                        .update({
                                      'busRouteNumber': '',
                                    });
                                  }
                                });

                                var school = context
                                    .read<AppCubit>()
                                    .state
                                    .currentSchool;

                                List<String> newBusRoutes = [];
                                school.routesNames.forEach((element) {
                                  if (element.toString() !=
                                      busRoute.busRouteNumber.toString()) {
                                    newBusRoutes.add(element);
                                  }
                                });

                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                            currentSchool: school.copyWith(
                                          routesNames: newBusRoutes,
                                        )));
                                context
                                    .read<AppCubit>()
                                    .state
                                    .currentSchool
                                    .updateSchoolOnFirestore(context
                                        .read<AppCubit>()
                                        .state
                                        .currentSchoolFirebaseDocId);
                                context.read<AppCubit>().updateState(
                                      context.read<AppCubit>().state.copyWith(
                                            currentBusRoute:
                                                BusRouteModel.empty(),
                                            currentBusRouteFirebaseDocId: "",
                                          ),
                                    );

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => SchoolListScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(child: const CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
