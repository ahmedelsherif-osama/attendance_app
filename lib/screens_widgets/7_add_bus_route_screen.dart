import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddBusRouteScreen extends StatelessWidget {
  AddBusRouteScreen({Key? key}) : super(key: key);
  final TextEditingController routeNumberController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    schoolNameController.text =
        context.read<AppCubit>().state.currentSchool.name;
    return Scaffold(
      appBar: AppBar(title: Text('Add Bus Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Add Bus Route"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextFormField(
              controller: routeNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Route Number',
              ),
            ),
            TextFormField(
              controller: schoolNameController,
              decoration: const InputDecoration(
                labelText: 'School Name',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ElevatedButton(
              onPressed: () async {
                print(routeNumberController.text + schoolNameController.text);
                context.read<AppCubit>().updateState(
                      context.read<AppCubit>().state.copyWith(
                            currentBusRoute: BusRouteModel(
                              busRouteNumber:
                                  int.parse(routeNumberController.text),
                              schoolName: schoolNameController.text,
                              areas: [],
                              studentsIDs: [],
                            ),
                          ),
                    );
                print(context
                    .read<AppCubit>()
                    .state
                    .currentBusRoute
                    .busRouteNumber);
                context
                    .read<AppCubit>()
                    .state
                    .currentBusRoute
                    .addBusRouteToFirestore();
                FirebaseFirestore.instance
                    .collection('schools')
                    .doc(context.read<AppCubit>().state.currentSchool.name)
                    .update({
                  'routesNames': FieldValue.arrayUnion([
                    context
                        .read<AppCubit>()
                        .state
                        .currentBusRoute
                        .busRouteNumber
                        .toString()
                  ])
                });

                FirebaseFirestore.instance
                    .collection('schools')
                    .where("name", isEqualTo: schoolNameController.text)
                    .get()
                    .then((value) {
                  value.docs.first.reference.update({
                    'routesNames':
                        FieldValue.arrayUnion([routeNumberController.text]),
                  });

                  context.go('/bus_route_screen');
                });
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
