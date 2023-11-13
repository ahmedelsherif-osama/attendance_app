import 'package:flutter/material.dart';

class ManageSchoolsBusRoutesStudentsPage extends StatelessWidget {
  const ManageSchoolsBusRoutesStudentsPage({super.key});
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
      ),
    );
  }
}
