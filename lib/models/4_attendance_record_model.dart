import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AttendanceRecordModel extends Equatable {
  const AttendanceRecordModel({
    required this.schoolName,
    required this.busRouteNumber,
    required this.studentAttendanceCheckboxes,
    required this.date,
  });
  final String schoolName;
  final String busRouteNumber;
  final Map<String, dynamic> studentAttendanceCheckboxes;
  final DateTime date;
  @override
  List<Object?> get props =>
      [schoolName, busRouteNumber, studentAttendanceCheckboxes, date];

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      schoolName: json['schoolName'] as String,
      busRouteNumber: json['busRouteNumber'] as String,
      studentAttendanceCheckboxes:
          json['studentAttendanceCheckboxes'] ?? [] as Map<String, dynamic>,
      date: json['date'] as DateTime,
    );
  }

  factory AttendanceRecordModel.empty() {
    return AttendanceRecordModel(
      schoolName: '',
      busRouteNumber: '',
      studentAttendanceCheckboxes: {},
      date: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'busRouteNumber': busRouteNumber,
      'studentAttendanceCheckboxes': studentAttendanceCheckboxes,
      'date': date,
    };
  }

  AttendanceRecordModel copyWith({
    String? schoolName,
    String? busRouteNumber,
    Map<String, dynamic>? studentAttendanceCheckboxes,
    DateTime? date,
  }) {
    return AttendanceRecordModel(
      schoolName: schoolName ?? this.schoolName,
      busRouteNumber: busRouteNumber ?? this.busRouteNumber,
      studentAttendanceCheckboxes:
          studentAttendanceCheckboxes ?? this.studentAttendanceCheckboxes,
      date: date ?? this.date,
    );
  }

  void addAttendanceRecordToFirestore() async {
    // Create a new instance of SchoolModel
    AttendanceRecordModel newAttendanceRecord = AttendanceRecordModel(
      schoolName: schoolName,
      busRouteNumber: busRouteNumber,
      studentAttendanceCheckboxes: studentAttendanceCheckboxes,
      date: date,
    );

    // Convert SchoolModel to JSON
    Map<String, dynamic> attendanceRecordJson = newAttendanceRecord.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance
        .collection('attendanceRecords')
        .add(attendanceRecordJson);
  }

  void updateAttendanceRecordOnFirestore(docId) async {
    // Create a new instance of SchoolModel
    AttendanceRecordModel newAttendanceRecord = AttendanceRecordModel(
      schoolName: schoolName,
      busRouteNumber: busRouteNumber,
      studentAttendanceCheckboxes: studentAttendanceCheckboxes,
      date: date,
    );

    // Convert SchoolModel to JSON
    Map<String, dynamic> attendanceRecordJson = newAttendanceRecord.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance
        .collection('attendanceRecords')
        .doc(docId)
        .update(attendanceRecordJson);
  }
}
