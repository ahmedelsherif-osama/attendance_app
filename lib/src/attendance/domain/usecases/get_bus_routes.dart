import 'package:attendance/core/usecases/usecases.dart';
import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/repositories/attendance_repository.dart';

class GetBusRoutes extends UseCaseWithoutParams {
  const GetBusRoutes(this._repository);
  final AttendanceRepository _repository;

  @override
  ResultFuture<List<BusRoute>> call() async => _repository.getBusRoutes();
}
