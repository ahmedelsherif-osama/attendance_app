import 'package:flutter/material.dart';

class ManageSchoolsBusRoutesStudentsPage extends StatelessWidget {
  const ManageSchoolsBusRoutesStudentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Manage your hubs"),
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
                  child: DropdownMenu(
                    dropdownMenuEntries: [
                      DropdownMenuEntry<String>(
                        value: "Route 1",
                        label: "Route 1",
                        enabled: true,
                      ),
                      DropdownMenuEntry<String>(
                        value: "Route 2",
                        label: "Route 2",
                        enabled: true,
                      ),
                      DropdownMenuEntry<String>(
                        value: "Route 3",
                        label: "Route 3",
                        enabled: true,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Text("School 1"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("School 2"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("School 3"),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: null, child: Text("")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
