import 'package:attendance/core/utils/router.dart';
import 'package:attendance/src/attendance/presentation/cubit/home_page_cubit.dart';
import 'package:attendance/src/attendance/presentation/pages/attendance_page.dart';
import 'package:attendance/src/attendance/presentation/pages/manage_schools_bus_routes_students_page.dart';
import 'package:attendance/src/attendance/presentation/widgets/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
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
                  child: Column(
                    children: [
                      Image.asset(
                        colorBlendMode: BlendMode.dstOver,
                        filterQuality: FilterQuality.high,

                        'images/logo.png', // Replace with your logo image asset
                        height: 100,
                        // Adjust the height as needed
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: BlocProvider<HomePageCubit>(
                          create: (context) => HomePageCubit(),
                          child: HomePageView(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
