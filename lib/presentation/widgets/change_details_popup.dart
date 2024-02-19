import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/3_bus_route_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChangeOption { BusRouteNumber, School }

class ChangeDetailsPopup extends StatefulWidget {
  @override
  _ChangeDetailsPopupState createState() => _ChangeDetailsPopupState();
}

class _ChangeDetailsPopupState extends State<ChangeDetailsPopup> {
  ChangeOption? _selectedOption;
  void updateBusRouteNumberOnCurrentBusRouteOnState(
      context, newBusRouteNumber) {
    var currentBusRoute =
        BlocProvider.of<AppCubit>(context).state.currentBusRoute;
    var newBusRoute =
        currentBusRoute.copyWith(busRouteNumber: newBusRouteNumber);
    var currentState = BlocProvider.of<AppCubit>(context).state;
    var newState = currentState.copyWith(currentBusRoute: newBusRoute);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  void updateBusRouteNumberOnCurrentBusRouteOnFirebase(
      currentBusRoute, busRouteDocId) {}

  void updateBusRouteNumberOnCurrentSchoolOnState(context, newBusRouteNumber) {
    var currentSchool = BlocProvider.of<AppCubit>(context).state.currentSchool;
    var currentRoutesNames = currentSchool.routesNames;

    if (currentRoutesNames.contains(newBusRouteNumber)) {
      return;
    }
    currentRoutesNames.add(newBusRouteNumber);
    var newRoutesNames = currentRoutesNames;
    var newSchool = currentSchool.copyWith(routesNames: newRoutesNames);

    var currentState = BlocProvider.of<AppCubit>(context).state;
    var newState = currentState.copyWith(currentSchool: newSchool);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  void updateBusRouteNumberOnCurrentSchoolOnFirebase(
      currentSchool, schoolDocId) {}

  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _busRouteNumberController = TextEditingController();

  bool _isEditingSchool = false;
  bool _isEditingBusRouteNumber = false;
  bool _isAddingNewSchool = false;
  List<String>? schoolNames;
  void initState() {
    super.initState();
    _fetchSchools().then((names) {
      setState(() {
        schoolNames = names;
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Details'),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_selectedOption == ChangeOption.BusRouteNumber) {
              final existingBusRoutesWithinSameSchool =
                  BlocProvider.of<AppCubit>(context)
                      .state
                      .currentSchool
                      .routesNames;
              final newBusRouteExists = existingBusRoutesWithinSameSchool
                  .contains(_busRouteNumberController.text);
              if (newBusRouteExists) {
                print("error");
              } else {
                updateBusRouteNumberOnCurrentBusRouteOnState(
                    context, int.parse(_busRouteNumberController.text));
                print(BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRoute
                    .busRouteNumber
                    .toString());
                updateBusRouteNumberOnCurrentSchoolOnState(
                    context, _busRouteNumberController.text);
                print(BlocProvider.of<AppCubit>(context)
                    .state
                    .currentSchool
                    .routesNames);

                final currentBusRoute =
                    BlocProvider.of<AppCubit>(context).state.currentBusRoute;
                final currentSchool =
                    BlocProvider.of<AppCubit>(context).state.currentSchool;
                final busRouteDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRouteFirebaseDocId;
                final schoolDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentSchoolFirebaseDocId;

                updateBusRouteNumberOnCurrentBusRouteOnFirebase(
                    currentBusRoute, busRouteDocId);
                print("busroute firebase");

                updateBusRouteNumberOnCurrentSchoolOnFirebase(
                    currentSchool, schoolDocId);
                print("school firebase");

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BusRouteScreen(),
                  ),
                );
              }
            } else if (_selectedOption == ChangeOption.School) {
              // Handle school change
              if (_isAddingNewSchool) {
                // Your function for adding a new school
                // YourFunctionForNewSchool(_schoolNameController.text);
              } else {
                // Your function for selecting from the dropdown
                // YourFunctionForSelectedSchool(_schoolNameController.text);
              }
            }

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Change Bus Route Number'),
          leading: Radio(
            value: ChangeOption.BusRouteNumber,
            groupValue: _selectedOption,
            onChanged: (ChangeOption? value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Change School'),
          leading: Radio(
            value: ChangeOption.School,
            groupValue: _selectedOption,
            onChanged: (ChangeOption? value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
        ),
        if (_selectedOption == ChangeOption.BusRouteNumber)
          _buildBusRouteNumberSection(),
        if (_selectedOption == ChangeOption.School) _buildSchoolSection(),
      ],
    );
  }

  Widget _buildBusRouteNumberSection() {
    return _buildTextField(
      label: 'Bus Route Number',
      controller: _busRouteNumberController,
      isEditing: _isEditingBusRouteNumber,
      onPressed: () {
        setState(() {
          _isEditingBusRouteNumber = !_isEditingBusRouteNumber;
          _isEditingSchool = false;
          _isAddingNewSchool = false;
        });
      },
    );
  }

  Widget _buildSchoolSection() {
    return _buildSchoolNameSection();
  }

  Widget _buildSchoolNameSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _isAddingNewSchool
                  ? _buildTextField(
                      label: 'New School Name',
                      controller: _schoolNameController,
                      isEditing: _isEditingSchool,
                      onPressed: () {},
                    )
                  : _buildDropdownMenu(),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Text('Add New School'),
            Checkbox(
              value: _isAddingNewSchool,
              onChanged: (value) {
                setState(() {
                  _isAddingNewSchool = value ?? false;
                  _isEditingSchool = _isAddingNewSchool;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      items: schoolNames!.map((String school) {
        return DropdownMenuItem<String>(
          value: school,
          child: Text(school),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _schoolNameController.text = value ?? '';
        });
      },
      decoration: InputDecoration(labelText: 'Select School'),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        )),
      ],
    );
  }
}
