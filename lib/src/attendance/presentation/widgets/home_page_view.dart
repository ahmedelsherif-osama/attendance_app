import 'package:attendance/src/attendance/presentation/cubit/home_page_cubit.dart';
import 'package:attendance/src/attendance/presentation/pages/attendance_page.dart';
import 'package:attendance/src/attendance/presentation/pages/manage_schools_bus_routes_students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<HomePageCubit, HomePageState>(
            builder: (context, state) {
              switch (state) {
                case 'Attendance':
                  return AttendancePage();
                case 'Manage':
                  return ManageSchoolsBusRoutesStudentsPage();
                case 'Home':
                  return Container(
                    width: 300,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            state.copyWith(
                                homePageStateEnum:
                                    HomePageStateEnum.Attendance);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                'icons/attendance_icon.jpg', // Replace with your attendance icon asset
                                height: 24,
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some spacing between the icon and text
                              const Text("Record Attendance"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            state.copyWith(
                                homePageStateEnum: HomePageStateEnum.Manage);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'icons/manage_icon.png', // Replace with your manage icon asset
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("Manage All"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                default:
                  return Container(
                    width: 300,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            state.copyWith(
                                homePageStateEnum:
                                    HomePageStateEnum.Attendance);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                'icons/attendance_icon.jpg', // Replace with your attendance icon asset
                                height: 24,
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some spacing between the icon and text
                              const Text("Record Attendance"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            state.copyWith(
                                homePageStateEnum: HomePageStateEnum.Manage);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'icons/manage_icon.png', // Replace with your manage icon asset
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("Manage All"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
