import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:equatable/equatable.dart';

class BusRoute extends Equatable {
  const BusRoute({
    required this.routeNumber,
    required this.schoolName,
    required this.area,
    required this.students,
  });

  const BusRoute.empty()
      : this(routeNumber: 0, area: '', schoolName: '', students: const []);

  final int routeNumber;
  final String schoolName;
  final String area;
  final List<Student> students;

  @override
  List<Object?> get props => [routeNumber, schoolName, area, students];
}
