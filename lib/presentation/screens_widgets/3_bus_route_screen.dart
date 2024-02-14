import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/4_attendance_record_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/5_student_details_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:final_rta_attendance/presentation/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteScreen extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => BusRouteScreen());

  Future<bool> checkIfBusRouteNumberExistsWithinSchool(
      busRouteNumber, schoolName) async {
    bool doesBusRouteExist = false;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('schools')
        .where('name', isEqualTo: schoolName)
        .get();
    var schoolFirebaseDocId = querySnapshot.docs.first.id;

    var schoolDoc = await FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolFirebaseDocId)
        .get();

    var data = schoolDoc.data();
    List<dynamic> routeNames = data?['routeNames'];
    if (routeNames.contains(busRouteNumber.toString())) {
      doesBusRouteExist = true;
    }
    return doesBusRouteExist;
  }

  Future<bool> checkIfNewSchoolExists(String newSchoolName) async {
    bool doesSchoolExist = false;
    var schoolsCollection = FirebaseFirestore.instance.collection('schools');

    // Query to check if a school with the given name already exists
    QuerySnapshot querySnapshot =
        await schoolsCollection.where('name', isEqualTo: newSchoolName).get();

    // If there is at least one document with the given name, set doesSchoolExist to true
    if (querySnapshot.docs.isNotEmpty) {
      doesSchoolExist = true;
    }

    return doesSchoolExist;
  }

  void removeRouteFromSchoolOnFireBaseDoc(
      busRouteNumber, schoolDocId, currentBusRouteNames) {
    final newBusRouteNames = [];
    currentBusRouteNames.forEach((Element) {
      if (Element.toString() != busRouteNumber.toString()) {
        newBusRouteNames.add(Element);
      }
    });
    FirebaseFirestore.instance
        .collection("schools")
        .doc(schoolDocId)
        .update({'busRouteName': newBusRouteNames});
  }

  bool checkIfSchoolIsChanged(originalSchool, newSchool) {
    if (originalSchool.toString() == newSchool.toString()) {
      return true;
    }
    return false;
  }

  bool checkIfBusRouteNumberIsChanged(originalBusRoute, newBusRoute) {
    if (originalBusRoute.toString() == newBusRoute.toString()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final BusRouteModel busRoute =
        context.read<AppCubit>().state.currentBusRoute;
    final SchoolModel school = context.read<AppCubit>().state.currentSchool;
    final busRouteNumberController =
        TextEditingController(text: busRoute.busRouteNumber.toString());
    final schoolNameController =
        TextEditingController(text: school.name.toString());
    final currentSchoolFirebaseDocId =
        context.read<AppCubit>().state.currentSchoolFirebaseDocId;

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
                    SizedBox(height: height * 0.1),
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
                                var isSchoolChanged = checkIfSchoolIsChanged(
                                    school.name, schoolNameController.text);
                                var isBusRouteNumberChanged =
                                    checkIfBusRouteNumberIsChanged(
                                        busRoute.busRouteNumber,
                                        busRouteNumberController.text);
                                if (isSchoolChanged == true) {
                                  if (isBusRouteNumberChanged == true) {
                                    removeRouteFromSchoolOnFireBaseDoc(
                                        busRoute.busRouteNumber,
                                        currentSchoolFirebaseDocId,
                                        school.routesNames);

                                    var doesNewSchoolExist =
                                        checkIfNewSchoolExists(
                                            schoolNameController.text);
                                    if (doesNewSchoolExist == true) {
                                      var doesBusRouteNumberExist =
                                          checkIfBusRouteNumberExistsWithinSchool(
                                              busRoute.busRouteNumber
                                                  .toString(),
                                              schoolNameController.text);

                                      if (doesBusRouteNumberExist == true) {
                                        print("already exists");
                                        return;
                                      }
                                      if (doesBusRouteNumberExist == false) {
                                        addBusRouteToSchool();
                                      }
                                    }
                                    if (doesNewSchoolExist == false) {
                                      createNewSchoolOnFireBase();
                                      addBusRouteToSchool();
                                    }
                                  }
                                  if (isBusRouteNumberChanged == false) {
                                    removeBusRouteFromSchoolOnFirebaseDoc();
                                    var doesNewSchoolExist =
                                        checkIfNewSchoolExist();
                                    if (doesNewSchoolExist == true) {
                                      var doesBusRouteNumberExist =
                                          checkIfBusRouteNumberExistsWithinSchool();

                                      if (doesBusRouteNumberExist == true) {
                                        print("already exists");
                                        return;
                                      }
                                      if (doesBusRouteNumberExist == false) {
                                        addBusRouteToSchool();
                                      }
                                    }
                                    if (doesNewSchoolExist == false) {
                                      createNewSchoolOnFireBase();
                                      addBusRouteToSchool();
                                    }
                                  }
                                  updateBusRouteDocOnFirebase();
                                  updateCurrentBusRouteOnState();
                                  updateCurrentSchoolDocOnFirebase();
                                  updateCurrentSchoolOnState();
                                  updateStudentsOnFirebase();
                                }
                                if (isSchoolChanged == false) {
                                  if (isBusRouteNumberChanged == true) {
                                    var doesBusRouteNumberExist =
                                        checkIfBusRouteNumberExistsWithinSchool();
                                    if (doesBusRouteNumberExist == true) {
                                      print("Already exists");
                                    }
                                    if (doesBusRouteNumberExist == false) {
                                      updateBusRouteNumberOnFirebaseDoc();
                                      updateCurrentBusRouteOnState();
                                      updateRouteNameOnSchoolOnFirebaseDoc();
                                      updateCurrentSchoolOnState();
                                      updateStudentsOnFireBase();
                                    }
                                  }
                                  if (isBusRouteNumberChanged == false) {
                                    return;
                                  }
                                }
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
                            var busRoute =
                                context.read<AppCubit>().state.currentBusRoute;
                            var busRouteDocId = context
                                .read<AppCubit>()
                                .state
                                .currentBusRouteFirebaseDocId;
                            busRoute.deleteBusRouteFromFirestore(busRouteDocId);
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

                            var school =
                                context.read<AppCubit>().state.currentSchool;

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
                                        currentBusRoute: BusRouteModel.empty(),
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
