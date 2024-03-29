import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/2_school_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSchoolScreen extends StatelessWidget {
  AddSchoolScreen({Key? key}) : super(key: key);
  final route = MaterialPageRoute(builder: (context) => AddSchoolScreen());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add School')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Add School"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
            TextFormField(
              controller: areaController,
              decoration: const InputDecoration(
                labelText: 'Area',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ElevatedButton(
              onPressed: () async {
                context.read<AppCubit>().updateState(
                      context.read<AppCubit>().state.copyWith(
                            currentSchool: SchoolModel(
                              name: nameController.text,
                              address: addressController.text,
                              area: areaController.text,
                              routesNames: [],
                            ),
                          ),
                    );
                context
                    .read<AppCubit>()
                    .state
                    .currentSchool
                    .addSchoolToFirestore();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SchoolScreen()),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
