import 'dart:convert';

import 'package:attendance/core/utils/typedef.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:equatable/equatable.dart';

class School extends Equatable {
  const School({
    required this.schoolName,
    required this.schoolArea,
    required this.busRoutes,
  });

  factory School.fromJson(String source) =>
      School.fromMap(jsonDecode(source) as DataMap);

  School.fromMap(DataMap map)
      : this(
          busRoutes: map['busRoutes'] as List<BusRoute>,
          schoolName: map['schoolName'] as String,
          schoolArea: map['schoolArea'] as String,
        );

  DataMap toMap() => {
        'schoolName': schoolName,
        'schoolArea': schoolArea,
        'busRoutes': busRoutes,
      };

  String toJson() => jsonEncode(toMap());

  const School.empty()
      : this(
          schoolName: '',
          schoolArea: '',
          busRoutes: const [],
        );

  School copyWith({
    String? schoolName,
    String? schoolArea,
    List<BusRoute>? busRoutes,
  }) {
    return School(
      schoolName: schoolName ?? this.schoolName,
      schoolArea: schoolArea ?? this.schoolArea,
      busRoutes: busRoutes ?? this.busRoutes,
    );
  }

  final String schoolName;
  final String schoolArea;
  final List<BusRoute> busRoutes;

  @override
  List<Object?> get props => [schoolName, schoolArea, busRoutes];
}
