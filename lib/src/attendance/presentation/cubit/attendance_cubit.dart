import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceState extends Equatable {
  final School? school;
  final BusRoute? busRoute;
  final List<BusRoute>? busRouteList;
  final List<Student>? studentList;

  const AttendanceState({
    required this.school,
    required this.busRoute,
    required this.busRouteList,
    required this.studentList,
  });

  @override
  List<Object?> get props => [school, busRoute, busRouteList, studentList];

  AttendanceState copyWith({
    School? school,
    BusRoute? busRoute,
    List<BusRoute>? busRouteList,
    List<Student>? studentList,
  }) {
    return AttendanceState(
      school: school ?? this.school,
      busRoute: busRoute ?? this.busRoute,
      busRouteList: busRouteList ?? this.busRouteList,
      studentList: studentList ?? this.studentList,
    );
  }
}

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit()
      : super(const AttendanceState(
          school: School.empty(),
          busRoute: BusRoute.empty(),
          busRouteList: [],
          studentList: [],
        ));

  void updateAttendance({
    School? school,
    BusRoute? busRoute,
    List<BusRoute>? busRouteList,
    List<Student>? studentList,
  }) {
    emit(state.copyWith(
      school: school,
      busRoute: busRoute,
      busRouteList: busRouteList,
      studentList: studentList,
    ));
  }
}
