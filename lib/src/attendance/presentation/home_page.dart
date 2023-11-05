import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 33,
            ),
            Title(
                color: Colors.red,
                child: const Text(
                  "Attendance App",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 40,
                  ),
                )),
            const SizedBox(
              height: 33,
            ),
            TextButton(
              onPressed: () => context.go('/attendance'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
              child: const Text(
                "Take or Check attendance",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => context.go('/manage-all'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
              child: const Text(
                "Manage: Schools - Bus Routes - Students",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
