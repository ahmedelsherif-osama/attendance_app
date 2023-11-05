import 'dart:convert';

import 'package:attendance/core/utils/typedef.dart';
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  factory Student.fromJson(String source) =>
      Student.fromMap(jsonDecode(source) as DataMap);

  Student.fromMap(DataMap map)
      : this(
          studentID: map['studentID'] as String,
          studentName: map['studentName'] as String,
          grade: map['grade'] as int,
          group: map['group'] as int,
          phoneNumber: map['phoneNumber'] as String,
          fathersNumber: map['fathersNumber'] as String,
          locationCoordinates: map['locationCoordinates'] as String,
          makkaniNumber: map['makkaniNumber'] as String,
          schoolName: map['schoolName'] as String,
          busRoute: map['busRoute'] as int,
        );

  DataMap toMap() => {
        'studentID': studentID,
        'studentName': studentName,
        'grade': grade,
        'group': group,
        'phoneNumber': phoneNumber,
        'fathersNumber': fathersNumber,
        'locationCoordinates': locationCoordinates,
        'makkaniNumber': makkaniNumber,
        'schoolName': schoolName,
        'busRoute': busRoute,
      };

  String toJson() => jsonEncode(toMap());

  const Student({
    required this.studentID,
    required this.studentName,
    required this.grade,
    required this.group,
    required this.phoneNumber,
    required this.fathersNumber,
    required this.locationCoordinates,
    required this.makkaniNumber,
    required this.schoolName,
    required this.busRoute,
  });

  const Student.empty()
      : this(
          fathersNumber: '',
          studentID: '',
          studentName: '',
          grade: 0,
          group: 0,
          phoneNumber: '',
          locationCoordinates: '',
          makkaniNumber: '',
          schoolName: '',
          busRoute: 0,
        );

  Student copyWith({
    String? studentID,
    String? studentName,
    int? grade,
    int? group,
    String? phoneNumber,
    String? fathersNumber,
    String? locationCoordinates,
    String? makkaniNumber,
    String? schoolName,
    int? busRoute,
  }) {
    return Student(
      studentID: studentID ?? this.studentID,
      studentName: studentName ?? this.studentName,
      grade: grade ?? this.grade,
      group: group ?? this.group,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fathersNumber: fathersNumber ?? this.fathersNumber,
      locationCoordinates: locationCoordinates ?? this.locationCoordinates,
      makkaniNumber: makkaniNumber ?? this.makkaniNumber,
      schoolName: schoolName ?? this.schoolName,
      busRoute: busRoute ?? this.busRoute,
    );
  }

  final String studentID;
  final String studentName;
  final int grade;
  final int group;
  final String phoneNumber;
  final String fathersNumber;
  final String locationCoordinates;
  final String makkaniNumber;
  final String schoolName;
  final int busRoute;

  @override
  List<Object?> get props => [
        studentID,
        studentName,
        grade,
        group,
        phoneNumber,
        fathersNumber,
        locationCoordinates,
        makkaniNumber,
        schoolName,
        busRoute,
      ];
}
