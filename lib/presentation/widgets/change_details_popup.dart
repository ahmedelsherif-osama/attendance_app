import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/1_school_model.dart';
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

  void addBusRouteNumberToSchoolOnState() {
    final currentBusRoute =
        BlocProvider.of<AppCubit>(context).state.currentBusRoute;

    final currentSchool =
        BlocProvider.of<AppCubit>(context).state.currentSchool;

    final currentBusRoutesNames = currentSchool.routesNames;
    currentBusRoutesNames.add(currentBusRoute.busRouteNumber.toString());
    final updatedCurrentSchool = currentSchool.copyWith(
      routesNames: currentBusRoutesNames,
    );
    final currentState = BlocProvider.of<AppCubit>(context).state;
    final newState = currentState.copyWith(
      currentSchool: updatedCurrentSchool,
    );
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  Future<void> updateCurrentSchoolToTargetSchoolPlusDocId(schoolName) async {
    final matchingSchoolsOnFirebase = await FirebaseFirestore.instance
        .collection("schools")
        .where('name', isEqualTo: schoolName)
        .get();
    final currentSchoolDocId = matchingSchoolsOnFirebase.docs.first.id;
    final fetchedSchool = matchingSchoolsOnFirebase.docs.first.data();
    final fetchedSchoolAsASchoolModel = SchoolModel.fromJson(fetchedSchool);
    final currentState = BlocProvider.of<AppCubit>(context).state;
    final newState = currentState.copyWith(
        currentSchoolFirebaseDocId: currentSchoolDocId,
        currentSchool: fetchedSchoolAsASchoolModel);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  Future<void> fetchAndUpdateCurrentSchoolIdFromFirebaseToState() async {
    final currentSchool =
        BlocProvider.of<AppCubit>(context).state.currentSchool;
    final matchingSchoolsOnFirebase = await FirebaseFirestore.instance
        .collection("schools")
        .where('name', isEqualTo: currentSchool.name)
        .get();
    final currentSchoolDocId = matchingSchoolsOnFirebase.docs.first.id;
    final currentState = BlocProvider.of<AppCubit>(context).state;
    final newState =
        currentState.copyWith(currentSchoolFirebaseDocId: currentSchoolDocId);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  Future<void> createSchoolOnFirebase() async {
    final currentSchool =
        BlocProvider.of<AppCubit>(context).state.currentSchool;
    FirebaseFirestore.instance
        .collection('schools')
        .add(currentSchool.toJson());
  }

  void createNewSchoolOnState(schoolName, busRouteNumber) {
    final currentState = BlocProvider.of<AppCubit>(context).state;
    final newSchool =
        SchoolModel(name: schoolName, routesNames: [busRouteNumber]);
    final newState = currentState.copyWith(currentSchool: newSchool);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  Future<void> updateCurrentSchoolRoutesNamesOnFirebase(
      currentSchoolFirebaseDocID) async {
    final routesNames =
        BlocProvider.of<AppCubit>(context).state.currentSchool.routesNames;
    FirebaseFirestore.instance
        .collection("schools")
        .doc(currentSchoolFirebaseDocID)
        .update({
      "routesNames": routesNames,
    });
  }

  void removeBusRouteFromCurrentSchoolOnState(context, busRouteNumber) {
    final currentSchool =
        BlocProvider.of<AppCubit>(context).state.currentSchool;
    final busRoutesNames = currentSchool.routesNames;
    busRoutesNames.remove(busRouteNumber);
    final updatedCurrentSchool =
        currentSchool.copyWith(routesNames: busRoutesNames);
    final newState = BlocProvider.of<AppCubit>(context)
        .state
        .copyWith(currentSchool: updatedCurrentSchool);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

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

  void updateSchoolNameOnCurrentBusRouteOnState(context, newSchoolName) {
    final currentBusRoute =
        BlocProvider.of<AppCubit>(context).state.currentBusRoute;
    var newBusRoute = currentBusRoute.copyWith(schoolName: newSchoolName);
    var currentState = BlocProvider.of<AppCubit>(context).state;
    var newState = currentState.copyWith(currentBusRoute: newBusRoute);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  void updateCurrentBusRouteOnFirebase(currentBusRoute, busRouteDocId) {
    currentBusRoute.updateBusRouteOnFirestore(busRouteDocId);
  }

  void updateBusRouteNumberOnCurrentSchoolOnState(
      context, newBusRouteNumber, oldBusRouteNumber) {
    var currentSchool = BlocProvider.of<AppCubit>(context).state.currentSchool;
    var currentRoutesNames = currentSchool.routesNames;

    if (currentRoutesNames.contains(newBusRouteNumber)) {
      return;
    }
    currentRoutesNames.remove(oldBusRouteNumber);
    currentRoutesNames.add(newBusRouteNumber);
    var newRoutesNames = currentRoutesNames;
    var newSchool = currentSchool.copyWith(routesNames: newRoutesNames);

    var currentState = BlocProvider.of<AppCubit>(context).state;
    var newState = currentState.copyWith(currentSchool: newSchool);
    BlocProvider.of<AppCubit>(context).updateState(newState);
  }

  void updateBusRouteNumberOnCurrentSchoolOnFirebase(
      currentSchool, schoolDocId) {
    currentSchool.updateSchoolOnFirestore(schoolDocId);
  }

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
                final oldBusRouteNumber = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRoute
                    .busRouteNumber
                    .toString();
                updateBusRouteNumberOnCurrentBusRouteOnState(
                    context, int.parse(_busRouteNumberController.text));
                print(BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRoute
                    .busRouteNumber
                    .toString());
                updateBusRouteNumberOnCurrentSchoolOnState(
                    context, _busRouteNumberController.text, oldBusRouteNumber);
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

                updateCurrentBusRouteOnFirebase(currentBusRoute, busRouteDocId);
                print("busroute firebase");

                updateBusRouteNumberOnCurrentSchoolOnFirebase(
                    currentSchool, schoolDocId);
                print("school firebase");

                Navigator.of(context).pop();
              }
            } else if (_selectedOption == ChangeOption.School) {
              if (_isAddingNewSchool) {
                // 1. record oldschool and oldbusroute details
                final oldSchoolDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentSchoolFirebaseDocId;

                final busRouteDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRouteFirebaseDocId;

                // 2. update busroute schoolname on state
                updateSchoolNameOnCurrentBusRouteOnState(
                    context, _schoolNameController.text);

                // 3. update busrouteschoolname on firebase
                final currentBusRoute =
                    BlocProvider.of<AppCubit>(context).state.currentBusRoute;

                print(currentBusRoute.schoolName);
                updateCurrentBusRouteOnFirebase(currentBusRoute, busRouteDocId);

                // 4. remove busroute from currentschool on state

                removeBusRouteFromCurrentSchoolOnState(
                    context, currentBusRoute.busRouteNumber.toString());

                // 5. remove busroute from currentschool on firebase
                updateCurrentSchoolRoutesNamesOnFirebase(oldSchoolDocId);

                // 6. create newschool on state - currentschool
                createNewSchoolOnState(_schoolNameController.text,
                    currentBusRoute.busRouteNumber.toString());

                // 7. create newschool on firebase with the busroute number
                createSchoolOnFirebase();

                // 8. update current school doc id on state
                fetchAndUpdateCurrentSchoolIdFromFirebaseToState();

                // setCurrentSchoolAsNewSchoolOnState(_schoolNameController.text);
                // final newSchool = createNewSchoolOnFirebase();
                // _schoolNameController.text;
              } else {
                // 1. double check if route name already exists on other school, return error if exists

                // 2. if it doesnt exist proceed

                // 3. record oldschool and oldbusroute details
                final oldSchoolDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentSchoolFirebaseDocId;
                final oldSchool =
                    BlocProvider.of<AppCubit>(context).state.currentSchool;
                final busRouteDocId = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRouteFirebaseDocId;
                final busRouteNumber = BlocProvider.of<AppCubit>(context)
                    .state
                    .currentBusRoute
                    .busRouteNumber
                    .toString();

                // 4. update busroute schoolname on state
                updateSchoolNameOnCurrentBusRouteOnState(
                    context, _schoolNameController.text);

                // 5. update busrouteschoolname on firebase
                final currentBusRoute =
                    BlocProvider.of<AppCubit>(context).state.currentBusRoute;
                updateCurrentBusRouteOnFirebase(currentBusRoute, busRouteDocId);

                // 6. remove busroute from currentschool on state
                final oldBusRoutesNames = oldSchool.routesNames;
                oldBusRoutesNames.remove(busRouteNumber);
                removeBusRouteFromCurrentSchoolOnState(
                    context, currentBusRoute.busRouteNumber.toString());

                // 7. remove busroute from currentschool on firebase
                updateCurrentSchoolRoutesNamesOnFirebase(oldSchoolDocId);

                // 8. get target school from firebase to state/currentschool
                // 9. get docId as well to state currentdocid
                updateCurrentSchoolToTargetSchoolPlusDocId(
                    _schoolNameController.text);

                // 10. update the currentschool on state to have the busroutenumber added to it
                addBusRouteNumberToSchoolOnState();

                // 11. update currentSchool on firebase
                final currentSchoolFirebaseDocID =
                    BlocProvider.of<AppCubit>(context)
                        .state
                        .currentSchoolFirebaseDocId;
                updateCurrentSchoolRoutesNamesOnFirebase(
                    currentSchoolFirebaseDocID);
              }
            }

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
