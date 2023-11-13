import 'package:attendance/core/utils/temp_dummy_data.dart';
import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:attendance/src/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialPage extends StatelessWidget {
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
                        hint: const Text(
                          "Select School",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        items: schoolList.map((school) {
                          return DropdownMenuItem<School>(
                            value: school,
                            child: Text(school.schoolName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          context
                              .read<AttendanceCubit>()
                              .updateAttendance(school: newValue as School);
                          context.read<AttendanceCubit>().updateAttendance(
                              busRouteList: newValue?.busRoutes);
                        },
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
