import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StudentModel extends Equatable {
  const StudentModel({
    required this.name,
    required this.studentID,
    required this.primaryPhoneNumber,
    required this.fatherPhoneNumber,
    required this.grade,
    required this.group,
    required this.longtitude,
    required this.latitude,
    required this.addressDescription,
    required this.makkani,
    required this.schoolName,
    required this.busRouteNumber,
  });
  final String name;
  final String studentID;
  final int primaryPhoneNumber;
  final int fatherPhoneNumber;
  final int grade;
  final int group;
  final double latitude;
  final double longtitude;
  final int makkani;
  final String addressDescription;
  final String schoolName;
  final String busRouteNumber;
  @override
  List<Object?> get props => [
        name,
        studentID,
        primaryPhoneNumber,
        fatherPhoneNumber,
        grade,
        group,
        longtitude,
        latitude,
        makkani,
        addressDescription,
        schoolName,
        busRouteNumber,
      ];

  factory StudentModel.empty() {
    return const StudentModel(
      name: '',
      studentID: '0',
      primaryPhoneNumber: 0,
      fatherPhoneNumber: 0,
      grade: 0,
      group: 0,
      longtitude: 0,
      latitude: 0,
      addressDescription: '',
      makkani: 0,
      schoolName: '',
      busRouteNumber: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentID': studentID,
      'primaryPhoneNumber': primaryPhoneNumber,
      'fatherPhoneNumber': fatherPhoneNumber,
      'grade': grade,
      'group': group,
      'longtitude': longtitude,
      'latitude': latitude,
      'makkani': makkani,
      'addressDescription': addressDescription,
      'schoolName': schoolName,
      'busRouteNumber': busRouteNumber,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'] as String,
      studentID: json['studentID'] as String,
      primaryPhoneNumber: json['primaryPhoneNumber'] ?? 0 as int,
      fatherPhoneNumber: json['fatherPhoneNumber'] as int,
      grade: json['grade'] as int,
      group: json['group'] as int,
      longtitude: json['longtitude'] as double,
      latitude: json['latitude'] as double,
      makkani: json['makkani'] as int,
      addressDescription: json['addressDescription'] as String,
      schoolName: json['schoolName'] as String,
      busRouteNumber: json['busRouteNumber'] as String,
    );
  }

  void addStudentToFirestore() async {
    // Create a new instance of SchoolModel
    StudentModel newStudent = StudentModel(
      name: name,
      studentID: studentID,
      primaryPhoneNumber: primaryPhoneNumber,
      fatherPhoneNumber: fatherPhoneNumber,
      grade: grade,
      group: group,
      longtitude: longtitude,
      latitude: latitude,
      makkani: makkani,
      addressDescription: addressDescription,
      schoolName: schoolName,
      busRouteNumber: busRouteNumber,
    );

    // Convert StudentModel to JSON
    Map<String, dynamic> studentJson = newStudent.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance.collection('students').add(studentJson);
  }

  static fromMap(Map<String, dynamic> data) {
    return StudentModel(
      name: data['name'] as String,
      studentID: data['studentID'] as String,
      primaryPhoneNumber: data['primaryPhoneNumber'] as int,
      fatherPhoneNumber: data['fatherPhoneNumber'] as int,
      grade: data['grade'] as int,
      group: data['group'] as int,
      longtitude: data['longtitude'] as double,
      latitude: data['latitude'] as double,
      makkani: data['makkani'] as int,
      addressDescription: data['addressDescription'] as String,
      schoolName: data['schoolName'] as String,
      busRouteNumber: data['busRouteNumber'] as String,
    );
  }
}
