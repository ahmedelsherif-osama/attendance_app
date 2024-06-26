import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_app/cubit/app_cubit.dart';
import 'package:attendance_app/models/1_school_model.dart';
import 'package:attendance_app/models/2_bus_route_model.dart';
import 'package:attendance_app/models/3_student_model.dart';
import 'package:attendance_app/presentation/screens_widgets/1_school_list.dart';
import 'package:attendance_app/presentation/screens_widgets/3_bus_route_screen.dart';
import 'package:attendance_app/presentation/screens_widgets/7_add_bus_route_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SchoolScreen extends StatelessWidget {
  SchoolScreen({Key? key}) : super(key: key);
  final route = MaterialPageRoute(builder: (context) => SchoolScreen());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    SchoolModel school = context.read<AppCubit>().state.currentSchool;
    String schoolName = school.name;
    List<String>? busRoutes = school.routesNames;

    return Scaffold(
      body: SizedBox(
        height: height * .80,
        width: width * .80,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('busRoutes').snapshots(),
          builder: (context, snapshot) {
            var areaController = TextEditingController();
            areaController.text =
                context.read<AppCubit>().state.currentSchool.area.toString();
            var addressController = TextEditingController();
            addressController.text =
                context.read<AppCubit>().state.currentSchool.address.toString();

            if (snapshot.hasData) {
              try {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .05,
                      ),
                      Text(schoolName),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormField(
                        onSaved: (newValue) {},
                        controller: areaController,
                        decoration: const InputDecoration(
                          labelText: 'Area',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                var busRoute = snapshot.data!.docs.firstWhere(
                                    (element) =>
                                        element['schoolName'] == schoolName &&
                                        element['busRouteNumber'] ==
                                            int.parse(busRoutes[index]));

                                var areas = busRoute['areas'];
                                var studentsIDs = busRoute['studentsIDs'];
                                var docID = snapshot.data!.docs
                                    .firstWhere((element) =>
                                        element['schoolName'] == schoolName &&
                                        element['busRouteNumber'] ==
                                            int.parse(busRoutes[index]))
                                    .id;
                                context.read<AppCubit>().updateState(
                                      context.read<AppCubit>().state.copyWith(
                                            currentBusRouteFirebaseDocId: docID,
                                          ),
                                    );
                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                            currentBusRoute: BusRouteModel(
                                          busRouteNumber:
                                              busRoute['busRouteNumber'],
                                          schoolName: busRoute['schoolName'],
                                          areas: areas.cast<String>(),
                                          studentsIDs:
                                              studentsIDs.cast<String>(),
                                        )));
                                context.read<AppCubit>().updateState(
                                      context.read<AppCubit>().state.copyWith(
                                          currentBusRouteFirebaseDocId: docID),
                                    );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BusRouteScreen(),
                                  ),
                                );
                              },
                              title: Text('Bus Route ${busRoutes[index]}'),
                              subtitle: Text(schoolName),
                              trailing: Icon(Icons.arrow_forward_ios),
                            );
                          },
                          itemCount: busRoutes.length,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.2,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<AppCubit>().updateState(
                                        context.read<AppCubit>().state.copyWith(
                                              currentSchool: SchoolModel(
                                                name: schoolName,
                                                area: areaController.text,
                                                address: addressController.text,
                                                routesNames: busRoutes,
                                              ),
                                            ),
                                      );

                                  context
                                      .read<AppCubit>()
                                      .state
                                      .currentSchool
                                      .updateSchoolOnFirestore(context
                                          .read<AppCubit>()
                                          .state
                                          .currentSchoolFirebaseDocId);
                                  Navigator.of(context).pushReplacement(route);
                                },
                                child: Text('Save changes'),
                              ),
                            ),
                            Container(
                              width: width * 0.2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddBusRouteScreen(),
                                    ),
                                  );
                                },
                                child: Text('Add Bus Route'),
                              ),
                            ),
                            Container(
                              width: width * .2,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AppCubit>()
                                      .state
                                      .currentSchool
                                      .deleteSchoolFromFirestore(context
                                          .read<AppCubit>()
                                          .state
                                          .currentSchoolFirebaseDocId);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SchoolListScreen(),
                                    ),
                                  );
                                },
                                child: Text('Delete School'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                return Center(child: const CircularProgressIndicator());
              }
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
