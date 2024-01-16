import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddStudentScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressDescriptionController =
      TextEditingController();
  final TextEditingController busRouteController = TextEditingController();
  final TextEditingController fatherPhoneNumberController =
      TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longtitudeController = TextEditingController();
  final TextEditingController makkaniController = TextEditingController();
  final TextEditingController primaryPhoneNumberController =
      TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    schoolNameController.text =
        context.read<AppCubit>().state.currentSchool.name;
    busRouteController.text = context
        .read<AppCubit>()
        .state
        .currentBusRoute
        .busRouteNumber
        .toString();

    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text("Add Student"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != String) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (int.tryParse(value!) == null || value.isEmpty) {
                            return 'Please enter a valid student ID';
                          }
                          return null;
                        },
                        controller: studentIDController,
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: primaryPhoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Primary phone number',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: fatherPhoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Father phone number',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid grade number';
                          }
                          return null;
                        },
                        controller: gradeController,
                        decoration: const InputDecoration(
                          labelText: 'Grade',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid group number';
                          }
                          return null;
                        },
                        controller: groupController,
                        decoration: const InputDecoration(
                          labelText: 'Group',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != String) {
                            return 'Please enter a valid school name';
                          }
                          return null;
                        },
                        controller: schoolNameController,
                        decoration: const InputDecoration(
                          labelText: 'School name',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid route number';
                          }
                          return null;
                        },
                        controller: busRouteController,
                        decoration: const InputDecoration(
                          labelText: 'Bus route number',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != String) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                        controller: addressDescriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.toString().runtimeType != double) {
                            return 'Please enter a valid latitude';
                          }
                          return null;
                        },
                        controller: latitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != double) {
                            return 'Please enter a valid longtitude';
                          }
                          return null;
                        },
                        controller: longtitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Longtitude',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value.runtimeType != int) {
                            return 'Please enter a valid makkani number';
                          }
                          return null;
                        },
                        controller: makkaniController,
                        decoration: const InputDecoration(
                          labelText: 'Makkani',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ElevatedButton(
              onPressed: () async {
                context.read<AppCubit>().updateState(
                      context.read<AppCubit>().state.copyWith(
                            currentStudent: StudentModel(
                              name: nameController.text,
                              studentID: studentIDController.text,
                              primaryPhoneNumber:
                                  int.parse(primaryPhoneNumberController.text),
                              fatherPhoneNumber:
                                  int.parse(fatherPhoneNumberController.text),
                              grade: int.parse(gradeController.text),
                              group: int.parse(groupController.text),
                              longtitude:
                                  double.parse(longtitudeController.text),
                              latitude: double.parse(latitudeController.text),
                              addressDescription:
                                  addressDescriptionController.text,
                              makkani: int.parse(makkaniController.text),
                              schoolName: schoolNameController.text,
                              busRouteNumber: busRouteController.text,
                            ),
                          ),
                    );
                context
                    .read<AppCubit>()
                    .state
                    .currentStudent
                    .addStudentToFirestore();
                context.go('/Student_screen');
              },
              child: const Text('Add'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
