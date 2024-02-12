import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/2_school_screen.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/6_add_school_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolListScreen extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => SchoolListScreen());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height * 0.80,
        width: width * 0.80,
        child: StreamBuilder(
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
                return SizedBox(
                  height: height * 0.80,
                  width: width * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width / 6,
                          ),
                          const Text(
                            "School List",
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
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
                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                          currentSchoolFirebaseDocId: docID,
                                        ));
                                var routesNames = school['routesNames'];
                                context.read<AppCubit>().updateState(
                                    context.read<AppCubit>().state.copyWith(
                                            currentSchool: SchoolModel(
                                          name: school['name'],
                                          address: school['address'],
                                          area: school['area'],
                                          routesNames:
                                              routesNames.cast<String>(),
                                        )));

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SchoolScreen(),
                                    ));
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width / 6,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AddSchoolScreen()),
                              );
                            },
                            child: const Text('Add School'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } catch (e) {
                return Text('Error: ${e.toString()}');
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
