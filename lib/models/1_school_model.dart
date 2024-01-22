import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SchoolModel extends Equatable {
  const SchoolModel({
    required this.name,
    this.address,
    this.area,
    required this.routesNames,
  });
  final String name;
  final String? address;
  final String? area;
  final List<String> routesNames;
  @override
  List<Object?> get props => [name, address, area, routesNames];

  factory SchoolModel.empty() {
    return const SchoolModel(
      name: '',
      address: '',
      area: '',
      routesNames: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'area': area,
      'routesNames': routesNames,
    };
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      name: json['name'] as String,
      address: json['address'] as String?,
      area: json['area'] as String?,
      routesNames: (json['routesNames'] as List<dynamic>).cast<String>(),
    );
  }
  SchoolModel copyWith({
    String? name,
    String? address,
    String? area,
    List<String>? routesNames,
  }) {
    return SchoolModel(
      name: name ?? this.name,
      address: address ?? this.address,
      area: area ?? this.area,
      routesNames: routesNames ?? this.routesNames,
    );
  }

  void addSchoolToFirestore() async {
    // Create a new instance of SchoolModel
    SchoolModel newSchool = SchoolModel(
        name: name, address: address, area: area, routesNames: routesNames);

    // Convert SchoolModel to JSON
    Map<String, dynamic> schoolJson = newSchool.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance.collection('schools').add(schoolJson);
  }

  void updateSchoolOnFirestore(docId) async {
    // Create a new instance of SchoolModel
    SchoolModel newSchool = SchoolModel(
        name: name, address: address, area: area, routesNames: routesNames);

    // Convert SchoolModel to JSON
    Map<String, dynamic> schoolJson = newSchool.toJson();

    // Add the document to Firestore
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(docId)
        .update(schoolJson);
  }

  void deleteSchoolFromFirestore(docId) async {
    // Create a new instance of SchoolModel
    SchoolModel newSchool = SchoolModel(
        name: name, address: address, area: area, routesNames: routesNames);

    // Convert SchoolModel to JSON
    Map<String, dynamic> schoolJson = newSchool.toJson();

    print(docId);

    // Add the document to Firestore
    await FirebaseFirestore.instance.collection('schools').doc(docId).delete();
  }
}
