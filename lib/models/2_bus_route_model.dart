import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BusRouteModel extends Equatable {
  const BusRouteModel({
    required this.busRouteNumber,
    required this.schoolName,
    required this.areas,
    required this.studentsIDs,
  });
  final int busRouteNumber;
  final String schoolName;
  final List<String> areas;
  final List<String> studentsIDs;

  @override
  List<Object?> get props => [busRouteNumber, schoolName, areas, studentsIDs];

  factory BusRouteModel.empty() {
    return const BusRouteModel(
      busRouteNumber: 0,
      schoolName: '',
      areas: [],
      studentsIDs: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busRouteNumber': busRouteNumber,
      'schoolName': schoolName,
      'areas': areas,
      'studentsIDs': studentsIDs,
    };
  }

  factory BusRouteModel.fromJson(Map<String, dynamic> json) {
    return BusRouteModel(
      busRouteNumber: json['busRouteNumber'] as int,
      schoolName: json['schoolName'] as String,
      areas: (json['areas'] as List<dynamic>).cast<String>(),
      studentsIDs: (json['studentsIDs'] as List<dynamic>).cast<String>(),
    );
  }

  void addBusRouteToFirestore() async {
    // Create a new instance of SchoolModel
    BusRouteModel newBusRoute = BusRouteModel(
      busRouteNumber: busRouteNumber,
      schoolName: schoolName,
      areas: areas,
      studentsIDs: studentsIDs,
    );

    // Convert SchoolModel to JSON
    Map<String, dynamic> busRouteJson = newBusRoute.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance.collection('busRoutes').add(busRouteJson);
  }
}
