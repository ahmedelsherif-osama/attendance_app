// import 'package:attendance/core/usecases/usecases.dart';
// import 'package:attendance/core/utils/typedef.dart';
// import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
// import 'package:attendance/src/attendance/domain/entities/student.dart';
// import 'package:attendance/src/attendance/domain/repositories/attendance_repository.dart';
// import 'package:equatable/equatable.dart';

// class AddBusRouteToSchool extends UseCaseWithParams<void, AddBusRouteToSchoolParams> {
//   const AddBusRouteToSchool(this._repository);
//   final AttendanceRepository _repository;

//   ResultVoid addBusRouteToSchool({
//     required String schoolName,
//     required String schoolArea,
//     required List<BusRoute> busRoutes,
//   }) async =>
//       _repository.createSchool(
//         schoolName: schoolName,
//         schoolArea: schoolArea,
//         busRoutes: busRoutes,
//       );

//   @override
//   ResultVoid call(AddBusRouteToSchoolParams params) async => _repository.addBusRouteToSchool(
//         schoolName: params.schoolName,
//         schoolArea: params.schoolArea,
//         busRoutes: params.busRoutes,
//       );
// }

// class AddBusRouteToSchoolParams extends Equatable {
  
//   final int routeNumber;
//   final String schoolName;
//   final String area;
//   final List<Student> students;

//   const AddBusRouteToSchoolParams.empty()
//       : this(
//           route
//           schoolName: '_empty.string',
//           schoolArea: '_empty.string',
//           busRoutes: const [],
//         );

//   const AddBusRouteToSchoolParams({
//     required this.schoolName,
//     required this.schoolArea,
//     required this.busRoutes,
//   });

//   @override
//   List<Object?> get props => [schoolName, schoolArea, busRoutes];
// }
