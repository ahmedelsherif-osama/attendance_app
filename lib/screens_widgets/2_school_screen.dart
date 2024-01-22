import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SchoolScreen extends StatelessWidget {
  SchoolScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchoolModel school = context.read<AppCubit>().state.currentSchool;
    String schoolName = school.name;
    print("this is the school name " + schoolName);
    List<String>? busRoutes = school.routesNames;
    List list = List.generate(busRoutes.length, (index) => busRoutes[index]);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('busRoutes').snapshots(),
        builder: (context, snapshot) {
          var areaController = TextEditingController();
          areaController.text =
              context.read<AppCubit>().state.currentSchool.area.toString();
          var addressController = TextEditingController();
          addressController.text =
              context.read<AppCubit>().state.currentSchool.address.toString();
          if (snapshot.hasData) {
            try {
              return Column(
                children: [
                  Text(schoolName),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextFormField(
                    onSaved: (newValue) {},
                    controller: areaController,
                    decoration: InputDecoration(
                      labelText: 'Area',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButton(
                          items: list
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('Bus Route ${e}'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            var busRoute = snapshot.data!.docs.firstWhere(
                                (element) =>
                                    element['schoolName'] == schoolName &&
                                    element['busRouteNumber'] ==
                                        int.parse(value.toString().substring(
                                            (value.toString().length - 1),
                                            value.toString().length)));
                            print("wtf is this? " + busRoute['schoolName']);
                            var areas = busRoute['areas'];
                            var studentsIDs = busRoute['studentsIDs'];

                            context.read<AppCubit>().updateState(
                                context.read<AppCubit>().state.copyWith(
                                        currentBusRoute: BusRouteModel(
                                      busRouteNumber:
                                          busRoute['busRouteNumber'],
                                      schoolName: busRoute['schoolName'],
                                      areas: areas.cast<String>(),
                                      studentsIDs: studentsIDs.cast<String>(),
                                    )));
                            context.go('/bus_route_screen');
                          },
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      ElevatedButton(
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
                          context.go('/');
                        },
                        child: Text('Save changes'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/add_bus_route_screen');
                        },
                        child: Text('Add Bus Route'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AppCubit>()
                              .state
                              .currentSchool
                              .deleteSchoolFromFirestore(context
                                  .read<AppCubit>()
                                  .state
                                  .currentFirebaseDocId);
                          context.go('/');
                        },
                        child: Text('Delete School'),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            print("this is the school nameee " + schoolName);
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
                                      studentsIDs: studentsIDs.cast<String>(),
                                    )));
                            context.go('/bus_route_screen');
                          },
                          title: Text('Bus Route ${busRoutes[index]}'),
                          subtitle: Text(schoolName),
                          trailing: Icon(Icons.arrow_forward_ios),
                        );
                      },
                      itemCount: busRoutes.length,
                    ),
                  ),
                ],
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
    );
  }
}
