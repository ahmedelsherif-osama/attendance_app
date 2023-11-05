import 'package:attendance/core/usecases/usecases.dart';
import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:attendance/src/attendance/domain/repositories/attendance_repository.dart';

class GetStudents extends UseCaseWithoutParams {
  const GetStudents(this._repository);
  final AttendanceRepository _repository;

  @override
  ResultFuture<List<Student>> call() async => _repository.getStudents();
}
