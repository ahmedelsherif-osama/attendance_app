import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/1_school_list.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/3_bus_route_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/3_bus_route_screen2.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/7_add_bus_route_screen.dart';

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
                                print(
                                    "this is the school nameee " + schoolName);
                                print("this is the busroutenumberrrr " +
                                    busRoutes[index]);

                                var busRoute = snapshot.data!.docs.firstWhere(
                                    (element) =>
                                        element['schoolName'] == schoolName &&
                                        element['busRouteNumber'] ==
                                            int.parse(busRoutes[index]));
                                print("wtf is this? " + busRoute['schoolName']);
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
                                            currentFirebaseDocId: docID,
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BusRouteScreen2(),
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
                                          .currentFirebaseDocId);
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
                                          .currentFirebaseDocId);
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
                print(e);
                return const CircularProgressIndicator();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
