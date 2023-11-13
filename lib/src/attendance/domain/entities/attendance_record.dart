import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:equatable/equatable.dart';

class AttendanceRecord extends Equatable {
  const AttendanceRecord({
    required this.dateTime,
    required this.attendance,
  });

  final DateTime dateTime;
  final Map<Student, bool> attendance;

  @override
  List<Object?> get props => [dateTime, attendance];
}
