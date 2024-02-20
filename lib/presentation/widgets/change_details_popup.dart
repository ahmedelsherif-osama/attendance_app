import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeDetailsPopup extends StatefulWidget {
  const ChangeDetailsPopup({super.key});
  @override
  State<ChangeDetailsPopup> createState() => _ChangeDetailsPopupState();
}

class _ChangeDetailsPopupState extends State<ChangeDetailsPopup> {
  var _changeSchoolOrBus;
  bool? _addingNewSchool = false;
  List<DropdownMenuEntry<dynamic>> schoolsDropDownEntries = [];
  List<String>? schoolNames;

  void initState() {
    super.initState();
    _fetchSchools().then((names) {
      setState(() {
        schoolNames = names;
        print(schoolNames);

        // Initialize and clear the dropdown items list
        schoolsDropDownEntries = [];

        // Populate dropdown items here
        schoolsDropDownEntries = schoolNames!
            .map((name) => DropdownMenuEntry(
                  value: name,
                  label: name,
                ))
            .toList();
      });
    });
  }

  Future<List<String>> _fetchSchools() async {
    try {
      var schools =
          await FirebaseFirestore.instance.collection('schools').get();
      return schools.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Handle any errors that occurred during the fetch
      print('Error fetching schools: $e');
      return [];
    }
  }

  Future<List<SchoolModel>> fetchSchools() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection("schools").get();
    List<SchoolModel>? schools = [];
    querySnapshot.docs
        .map(
            (e) => schools.add(SchoolModel.fromJson(e as Map<String, dynamic>)))
        .toList();
    schools.forEach((element) {
      print("tes ${element.name}");
    });
    return schools;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final busRouteNumberController = TextEditingController();
    busRouteNumberController.text = BlocProvider.of<AppCubit>(context)
        .state
        .currentBusRoute
        .busRouteNumber
        .toString();
    final schoolNameController = TextEditingController();

    return Dialog(
      child: Container(
        height: height / 2,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: _changeSchoolOrBus,
                    groupValue: "Change Bus Route Number",
                    onChanged: (value) {
                      setState(() {
                        _changeSchoolOrBus = "Change Bus Route Number";
                        print("bus");
                      });
                    }),
                Text("Change Bus Route Number"),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: _changeSchoolOrBus,
                    groupValue: "Change School",
                    onChanged: (value) {
                      setState(() {
                        _changeSchoolOrBus = "Change School";
                        print("school");
                      });
                    }),
                Text("Change School"),
              ],
            ),
            if (_changeSchoolOrBus == "Change Bus Route Number")
              TextFormField(
                controller: busRouteNumberController,
              ),
            if (_changeSchoolOrBus == "Change School")
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _addingNewSchool,
                        onChanged: (bool? value) {
                          setState(() {
                            _addingNewSchool = value;
                          });
                        },
                      ),
                      Text("Adding New School"),
                    ],
                  ),
                  if (_addingNewSchool == true)
                    TextFormField(
                      controller: schoolNameController,
                      decoration: InputDecoration(labelText: 'New School Name'),
                    ),
                  if (_addingNewSchool == false)
                    DropdownMenu(dropdownMenuEntries: schoolsDropDownEntries)
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      if (_changeSchoolOrBus == "Change Bus Route Number") {
                        // 1. update busroutenumber on currentbusroute on state
                        final currentBusRoute =
                            context.read<AppCubit>().state.currentBusRoute;
                        final updatedCurrentBusRoute = currentBusRoute.copyWith(
                            busRouteNumber:
                                int.parse(busRouteNumberController.text));
                        final currentState = context.read<AppCubit>().state;
                        final newState = currentState.copyWith(
                            currentBusRoute: updatedCurrentBusRoute);
                        context.read<AppCubit>().updateState(newState);
                        print(context
                            .read<AppCubit>()
                            .state
                            .currentBusRoute
                            .busRouteNumber
                            .toString());
                        // 2. update busroutenumber on currentbusroute on firebase
                        // 3. update busroutesnumber on students on firebase
                        // 4. update busroutenumber on currentschool on state
                        // 5. update busroutenumber on currentschool on firebase
                      }
                    },
                    child: Text("Save")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
