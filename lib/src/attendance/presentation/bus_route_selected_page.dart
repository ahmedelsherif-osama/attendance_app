import 'package:attendance/core/utils/temp_dummy_data.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:attendance/src/attendance/presentation/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRouteSelectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '/images/background.jpg'), // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    backgroundBlendMode: BlendMode.colorDodge,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    colorBlendMode: BlendMode.dstOver,
                    filterQuality: FilterQuality.high,

                    'images/logo.png', // Replace with your logo image asset
                    height: 100,
                    // Adjust the height as needed
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                    ),
                    Center(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                          backgroundBlendMode: BlendMode.difference),
                      child: DropdownButton(
                        hint: Text(
                          context
                              .read<AttendanceCubit>()
                              .state
                              .school!
                              .schoolName,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        items: schoolList.map((school) {
                          return DropdownMenuItem<School>(
                            value: school,
                            child: Text(school.schoolName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<AttendanceCubit>().updateAttendance(
                              school: newValue as School,
                              busRoute: BusRoute.empty());
                          context.read<AttendanceCubit>().updateAttendance(
                              busRouteList: newValue?.busRoutes);
                        },
                      ),
                    )),
                    SizedBox(
                      width: 30,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.difference),
                        child: DropdownButton(
                          hint: Text(
                            "Bus route ${context.read<AttendanceCubit>().state.busRoute!.routeNumber}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          items: context
                              .read<AttendanceCubit>()
                              .state
                              .busRouteList
                              ?.map((busRouteList) {
                            return DropdownMenuItem<BusRoute>(
                              value: busRouteList,
                              child: Text(
                                "Route ${busRouteList.routeNumber.toString()}",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            context.read<AttendanceCubit>().updateAttendance(
                                busRoute: newValue as BusRoute?);
                            context.read<AttendanceCubit>().updateAttendance(
                                studentList: newValue?.students);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 300,
                  width: 1000, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: context
                        .read<AttendanceCubit>()
                        .state
                        .studentList!
                        .length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              backgroundBlendMode: BlendMode.clear),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(context
                                  .read<AttendanceCubit>()
                                  .state
                                  .studentList![index]
                                  .studentID),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                context
                                    .read<AttendanceCubit>()
                                    .state
                                    .studentList![index]
                                    .studentName,
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Text(
                                context
                                    .read<AttendanceCubit>()
                                    .state
                                    .studentList![index]
                                    .fathersNumber,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                context
                                    .read<AttendanceCubit>()
                                    .state
                                    .studentList![index]
                                    .phoneNumber,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Grade ${context.read<AttendanceCubit>().state.studentList![index].grade} "
                                "Group ${context.read<AttendanceCubit>().state.studentList![index].group}",
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {
                                  if (newValue == true) {
                                    context
                                        .read<AttendanceCubit>()
                                        .updateAttendance(
                                            school: School.empty());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
