import 'package:attendance/core/usecases/usecases.dart';
import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/repositories/attendance_repository.dart';
import 'package:equatable/equatable.dart';

class CreateSchool extends UseCaseWithParams<void, CreateSchoolParams> {
  const CreateSchool(this._repository);
  final AttendanceRepository _repository;

  ResultVoid createSchool({
    required String schoolName,
    required String schoolArea,
    required List<BusRoute> busRoutes,
  }) async =>
      _repository.createSchool(
        schoolName: schoolName,
        schoolArea: schoolArea,
        busRoutes: busRoutes,
      );

  @override
  ResultVoid call(CreateSchoolParams params) async => _repository.createSchool(
        schoolName: params.schoolName,
        schoolArea: params.schoolArea,
        busRoutes: params.busRoutes,
      );
}

class CreateSchoolParams extends Equatable {
  final String schoolName;
  final String schoolArea;
  final List<BusRoute> busRoutes;

  const CreateSchoolParams.empty()
      : this(
          schoolName: '_empty.string',
          schoolArea: '_empty.string',
          busRoutes: const [],
        );

  const CreateSchoolParams({
    required this.schoolName,
    required this.schoolArea,
    required this.busRoutes,
  });

  @override
  List<Object?> get props => [schoolName, schoolArea, busRoutes];
}
