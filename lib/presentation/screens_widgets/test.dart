import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Replace 'YourNewSchoolName' with the name you want to check
  bool schoolExists = await checkIfNewSchoolExists('YourNewSchoolName');

  print('School exists: $schoolExists');
}

Future<bool> checkIfNewSchoolExists(String newSchoolName) async {
  bool doesSchoolExist = false;
  var schoolsCollection = FirebaseFirestore.instance.collection('schools');

  // Query to check if a school with the given name already exists
  QuerySnapshot querySnapshot =
      await schoolsCollection.where('name', isEqualTo: newSchoolName).get();

  // If there is at least one document with the given name, set doesSchoolExist to true
  if (querySnapshot.docs.isNotEmpty) {
    doesSchoolExist = true;
  }

  return doesSchoolExist;
}
