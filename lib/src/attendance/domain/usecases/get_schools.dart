import 'package:attendance/core/usecases/usecases.dart';
import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/repositories/attendance_repository.dart';

class GetSchools extends UseCaseWithoutParams {
  const GetSchools(this._repository);
  final AttendanceRepository _repository;

  @override
  ResultFuture<List<School>> call() async => _repository.getSchools();
}
