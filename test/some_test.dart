import 'package:final_rta_attendance/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:final_rta_attendance/presentation/screens_widgets/9_attendance_screen.dart'
    as SourceWidget; // Import the file where fetchAttendanceRecordsWithDocIds is defined
import 'package:final_rta_attendance/models/4_attendance_record_model.dart'; // Import your model file

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  test(
      'fetchAttendanceRecordsWithDocIds returns null or list of AttendanceRecordModel',
      () async {
    // Initialize Firebase with the Firebase app configuration.
    // Ensure Firebase has been initialized before running the test.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Call the function under test
    final result = await SourceWidget.AttendanceScreen()
        .fetchAttendanceRecordsWithDocIds("bs school", "1");
    print(result);

    // Verify the result
    if (result == null) {
      // If the result is null, the function should return null
      expect(result, isNull);
    } else {
      // If the result is not null, it should be a list of AttendanceRecordModel
      expect(result, isA<Map<String, AttendanceRecordModel>>());

      // Optional: Add more assertions to validate the contents of the map
      // For example:
      // expect(result.length, greaterThan(0));
    }
  });
}
