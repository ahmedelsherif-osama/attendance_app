import 'package:attendance_app/presentation/screens_widgets/8_add_student_screen.dart';
import 'package:flutter/material.dart';

class NoStudentsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            const Text("No students yet!"),
            SizedBox(
              height: height * 0.2,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudentScreen(),
                    ),
                  );
                },
                child: const Text("Add student")),
          ],
        ),
      ),
    );
  }
}
