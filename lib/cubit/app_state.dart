import 'package:equatable/equatable.dart';
import 'package:attendance_app/models/2_bus_route_model.dart';
import 'package:attendance_app/models/1_school_model.dart';
import 'package:attendance_app/models/3_student_model.dart';
import 'package:attendance_app/models/4_attendance_record_model.dart';

class AppState extends Equatable {
  const AppState({
    required this.schools,
    required this.busRoutes,
    required this.students,
    required this.currentSchool,
    required this.currentBusRoute,
    required this.currentStudent,
    required this.currentDate,
    required this.currentAttendanceRecord,
    required this.currentSchoolFirebaseDocId,
    required this.currentBusRouteFirebaseDocId,
    required this.currentStudentFirebaseDocId,
    required this.currentAttendanceRecordFirebaseDocId,
  });
  final List<SchoolModel> schools;
  final List<BusRouteModel> busRoutes;
  final List<StudentModel> students;
  final SchoolModel currentSchool;
  final BusRouteModel currentBusRoute;
  final StudentModel currentStudent;
  final DateTime currentDate;
  final AttendanceRecordModel currentAttendanceRecord;
  final String currentSchoolFirebaseDocId;
  final String currentBusRouteFirebaseDocId;
  final String currentStudentFirebaseDocId;
  final String currentAttendanceRecordFirebaseDocId;

  @override
  // TODO: implement props
  List<Object?> get props => [
        schools,
        busRoutes,
        students,
        currentSchool,
        currentBusRoute,
        currentStudent,
        currentDate,
        currentAttendanceRecord,
        currentSchoolFirebaseDocId,
        currentBusRouteFirebaseDocId,
        currentStudentFirebaseDocId,
        currentAttendanceRecordFirebaseDocId,
      ];
  @override
  bool get stringify => true;

  AppState copyWith({
    List<SchoolModel>? schools,
    List<BusRouteModel>? busRoutes,
    List<StudentModel>? students,
    SchoolModel? currentSchool,
    BusRouteModel? currentBusRoute,
    StudentModel? currentStudent,
    DateTime? currentDate,
    AttendanceRecordModel? currentAttendanceRecord,
    String? currentSchoolFirebaseDocId,
    String? currentBusRouteFirebaseDocId,
    String? currentStudentFirebaseDocId,
    String? currentAttendanceRecordFirebaseDocId,
  }) {
    return AppState(
      schools: schools ?? this.schools,
      busRoutes: busRoutes ?? this.busRoutes,
      students: students ?? this.students,
      currentSchool: currentSchool ?? this.currentSchool,
      currentBusRoute: currentBusRoute ?? this.currentBusRoute,
      currentStudent: currentStudent ?? this.currentStudent,
      currentDate: currentDate ?? this.currentDate,
      currentAttendanceRecord:
          currentAttendanceRecord ?? this.currentAttendanceRecord,
      currentSchoolFirebaseDocId:
          currentSchoolFirebaseDocId ?? this.currentSchoolFirebaseDocId,
      currentBusRouteFirebaseDocId:
          currentBusRouteFirebaseDocId ?? this.currentBusRouteFirebaseDocId,
      currentStudentFirebaseDocId:
          currentStudentFirebaseDocId ?? this.currentStudentFirebaseDocId,
      currentAttendanceRecordFirebaseDocId:
          currentAttendanceRecordFirebaseDocId ??
              this.currentAttendanceRecordFirebaseDocId,
    );
  }

  factory AppState.empty() {
    return AppState(
      schools: [],
      busRoutes: [],
      students: [],
      currentSchool: SchoolModel.empty(),
      currentBusRoute: BusRouteModel.empty(),
      currentStudent: StudentModel.empty(),
      currentDate: DateTime.now(),
      currentAttendanceRecord: AttendanceRecordModel.empty(),
      currentSchoolFirebaseDocId: '',
      currentBusRouteFirebaseDocId: '',
      currentStudentFirebaseDocId: '',
      currentAttendanceRecordFirebaseDocId: '',
    );
  }
}
