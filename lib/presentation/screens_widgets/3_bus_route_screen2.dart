import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/4_attendance_record_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:final_rta_attendance/presentation/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteScreen2 extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => BusRouteScreen2());

  @override
  Widget build(BuildContext context) {
    final BusRouteModel busRoute =
        context.read<AppCubit>().state.currentBusRoute;
    final SchoolModel school = context.read<AppCubit>().state.currentSchool;
    final busRouteNumberController =
        TextEditingController(text: busRoute.busRouteNumber.toString());
    final schoolNameController =
        TextEditingController(text: school.name.toString());

    // List studentList = busRoute.studentsIDs;
    List studentList = [
      "student 1",
      "student 2",
      "student 3",
      "student 4",
    ];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.1, horizontal: width * 0.1),
        child: StreamBuilder<Object>(
            stream:
                FirebaseFirestore.instance.collection('students').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                          child: TextFormField(
                            controller: busRouteNumberController,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: const Text("School: "),
                        ),
                        SizedBox(
                          width: width * 0.3,
                          child: TextFormField(
                            controller: schoolNameController,
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentList.length,
                        itemBuilder: (context, index) {
                          print(studentList[index]);
                          return Text(studentList[index].toString());
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.1),
                    Column(
                      children: [
                        CustomButton(
                          height: height,
                          width: width,
                          text: "Take Attendance",
                          color: Colors.green,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AttendanceRecordScreen(),
                              ),
                            );
                          },
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
                              text: "Save Changes",
                              onTap: () {
                                Navigator.of(context).pushReplacement(route);
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
                        CustomButton(
                          height: height,
                          width: width,
                          color: Colors.red,
                          text: "Delete Bus Route",
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SchoolListScreen(),
                              ),
                            );
                          },
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
