import 'package:attendance/core/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageView extends StatelessWidget {
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
                const SizedBox(height: 50),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/attendance'),
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
                        onPressed: () => context.go('/manage-all'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
