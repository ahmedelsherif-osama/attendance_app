import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';

import 'package:final_rta_attendance/models/1_school_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SchoolList extends StatelessWidget {
  SchoolList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('schools').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              List<SchoolModel> schoolList = [];

              snapshot.data!.docs.forEach((element) {
                schoolList.add(
                  SchoolModel(
                    name: element['name'],
                    address: element['address'],
                    area: element['area'],
                    routesNames: element['routesNames'].cast<String>(),
                  ),
                );
              });
              context.read<AppCubit>().updateState(
                    context.read<AppCubit>().state.copyWith(
                          schools: schoolList,
                        ),
                  );
              List list = List.generate(
                  schoolList.length, (index) => schoolList[index].name);
              return Container(
                child: Column(
                  children: [
                    const Text("School List"),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Row(
                      children: [
                        Flexible(
                          child: DropdownButton(
                            items: list
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              var school = snapshot.data!.docs.firstWhere(
                                  (element) =>
                                      element['name'] == value.toString());
                              var routesNames = school['routesNames'];
                              context.read<AppCubit>().updateState(
                                  context.read<AppCubit>().state.copyWith(
                                          currentSchool: SchoolModel(
                                        name: school['name'],
                                        address: school['address'],
                                        area: school['area'],
                                        routesNames: routesNames.cast<String>(),
                                      )));
                              context.go('/school_screen');
                            },
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/add_school_screen');
                          },
                          child: const Text('Add School'),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: schoolList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(schoolList[index].name),
                            onTap: () {
                              var school = snapshot.data!.docs.firstWhere(
                                  (element) =>
                                      element['name'] ==
                                      schoolList[index].name);
                              var docID = school.id;
                              context.read<AppCubit>().updateState(context
                                  .read<AppCubit>()
                                  .state
                                  .copyWith(
                                      currentAttendanceRecordFirebaseDocId:
                                          docID));
                              var routesNames = school['routesNames'];
                              context.read<AppCubit>().updateState(
                                  context.read<AppCubit>().state.copyWith(
                                          currentSchool: SchoolModel(
                                        name: school['name'],
                                        address: school['address'],
                                        area: school['area'],
                                        routesNames: routesNames.cast<String>(),
                                      )));

                              context.go('/school_screen');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } catch (e) {
              return Text('Error: ${e.toString()}');
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
