import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Attendance"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: DropdownMenu(
                    dropdownMenuEntries: [
                      DropdownMenuEntry<String>(
                        value: "School 1",
                        label: "School 1",
                        enabled: true,
                      ),
                      DropdownMenuEntry<String>(
                        value: "School 2",
                        label: "School 2",
                        enabled: true,
                      ),
                      DropdownMenuEntry<String>(
                        value: "School 3",
                        label: "School 3",
                        enabled: true,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Text("Student 1"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Student 2"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Student 3"),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
