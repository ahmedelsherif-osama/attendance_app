import 'package:final_rta_attendance/cubit/app_cubit.dart';
import 'package:final_rta_attendance/models/2_bus_route_model.dart';
import 'package:final_rta_attendance/presentation/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteScreen2 extends StatelessWidget {
  final route = MaterialPageRoute(builder: (context) => BusRouteScreen2());

  @override
  Widget build(BuildContext context) {
    BusRouteModel busRoute = context.read<AppCubit>().state.currentBusRoute;

    // List studentList = busRoute.studentsIDs;
    List studentList = [
      "student 1",
      "student 2",
      "student 3",
      "student 4",
    ];
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
            SizedBox(
              height: height * 0.1,
            ),
            SizedBox(
              height: height * 0.05,
              child: const Text("Students:"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  print(studentList[index]);
                  return Text(studentList[index].toString());
                },
              ),
            ),
            SizedBox(height: height * 0.1),
            Column(
              children: [
                CustomButton(
                    height: height,
                    width: width,
                    text: "Take Attendance",
                    color: Colors.green),
                SizedBox(
                  height: height * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                        height: height,
                        width: width,
                        color: Colors.blue,
                        text: "Save Changes"),
                    CustomButton(
                        height: height,
                        width: width,
                        color: Colors.blue,
                        text: "Add Student"),
                  ],
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                CustomButton(
                    height: height,
                    width: width,
                    color: Colors.red,
                    text: "Delete Bus Route"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
