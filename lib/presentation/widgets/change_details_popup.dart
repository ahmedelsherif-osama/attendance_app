import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeDetailsPopup extends StatefulWidget {
  @override
  _ChangeDetailsPopupState createState() => _ChangeDetailsPopupState();
}

class _ChangeDetailsPopupState extends State<ChangeDetailsPopup> {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isEditingBusRouteNumber) _buildSchoolNameSection(),
          if (!_isEditingSchool)
            _buildTextField(
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
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_isEditingSchool) {
              if (_isAddingNewSchool) {
                // Your function for adding a new school
                // YourFunctionForNewSchool(_schoolNameController.text);
              } else {
                // Your function for selecting from the dropdown
                // YourFunctionForSelectedSchool(_schoolNameController.text);
              }
            } else if (_isEditingBusRouteNumber) {
              // Your function for bus route number
              // YourFunctionForBusRouteNumber(_busRouteNumberController.text);
            }

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
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
            // IconButton(
            //   icon: Icon(_isEditingSchool ? Icons.save : Icons.edit),
            //   onPressed: () {
            //     setState(() {
            //       _isEditingSchool = !_isEditingSchool;
            //       _isAddingNewSchool = false;
            //     });
            //   },
            // ),
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
    // Replace this with the actual list of schools from your data source

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
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: label),
                )
              : InputDecorator(
                  decoration: InputDecoration(labelText: label),
                  child: Text(
                    controller.text,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
        ),
        // IconButton(
        //   icon: Icon(isEditing ? Icons.save : Icons.edit),
        //   onPressed: onPressed,
        // ),
      ],
    );
  }
}
