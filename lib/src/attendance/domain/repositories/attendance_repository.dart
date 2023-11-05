import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';

abstract class AttendanceRepository {
  const AttendanceRepository();

  ResultVoid addStudentToBusRouteToSchool({
    required String studentID,
    required String studentName,
    required int grade,
    required int group,
    required String phoneNumber,
    required String fathersNumber,
    required String locationCoordinates,
    required String makkaniNumber,
    required String schoolName,
    required int busRoute,
  });
  ResultFuture<List<Student>> getStudents();

  ResultVoid createSchool({
    required String schoolName,
    required String schoolArea,
    required List<BusRoute> busRoutes,
  });

  ResultFuture<List<School>> getSchools();

  ResultVoid addBusRouteToSchool({
    required String schoolName,
    required String area,
    required List<Student> students,
  });
  ResultFuture<List<BusRoute>> getBusRoutes();
}
