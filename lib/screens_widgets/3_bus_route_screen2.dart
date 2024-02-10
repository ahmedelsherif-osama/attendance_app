import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/cubit/app_state.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/models/3_student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteScreen2 extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => BusRouteScreen2());

  @override
  Widget build(BuildContext context) {
    BusRouteModel busRoute = context.read<AppCubit>().state.currentBusRoute;

    List studentList = busRoute.studentsIDs;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.1, horizontal: width * 0.1),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: width * 0.2,
                  child: const Text("Bus Route: "),
                ),
                SizedBox(
                  width: width * 0.1,
                  child: TextFormField(initialValue: "1"),
                ),
                SizedBox(
                  width: width * 0.2,
                  child: const Text("School: "),
                ),
                SizedBox(
                  width: width * 0.3,
                  child: TextFormField(initialValue: "Apple School"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
