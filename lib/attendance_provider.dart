import 'dart:async';

import 'package:attendance_scanner/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'student_model.dart';
import 'package:flutter/services.dart';

class AttendanceProvider extends ChangeNotifier {
  List<Student> _students = [];
  final LocalAuthentication _localAuth = LocalAuthentication();
  DateTime _selectedDate = DateTime.now();
  bool _isBiometricAvailable = false;
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _studentsSubscription;

  AttendanceProvider() {
    initBiometrics();
    _loadStudents();
  }

  void _loadStudents() {
    _studentsSubscription = _firestoreService.getStudents().listen((students) {
      _students = students;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _studentsSubscription?.cancel();
    super.dispose();
  }

  List<Student> get students => _students;
  DateTime get selectedDate => _selectedDate;
  bool get isBiometricAvailable => _isBiometricAvailable;

  Future<void> initBiometrics() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();
      notifyListeners();
    } catch (e) {
      print("Error initializing biometrics: $e");
      _isBiometricAvailable = false;
    }
  }

  Future<void> markAttendance(String studentId) async {
    try {
      // 1. Check if device supports biometrics
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!isDeviceSupported) {
        print("Device does not support biometric authentication");
        return;
      }

      // 2. Check if biometric sensors are available
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        print("No biometric sensors available");
        return;
      }

      // 3. Check if biometrics are enrolled
      final List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        print("No biometrics enrolled on this device");
        return;
      }

      // 4. Authenticate user
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Verify your identity to mark attendance',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
        final studentIndex = _students.indexWhere((s) => s.id == studentId);

        if (studentIndex != -1) {
          final student = _students[studentIndex];
          final newAttendance = Map<String, bool>.from(student.attendance);

          // Only mark if not already marked
          if (!(newAttendance[dateKey] ?? false)) {
            newAttendance[dateKey] = true;

            await _firestoreService.updateAttendance(studentId, newAttendance);

            _students[studentIndex] = student.copyWith(attendance: newAttendance);
            notifyListeners();

            print("Attendance marked for ${student.name}");
          } else {
            print("Attendance already marked for ${student.name}");
          }
        }
      } else {
        print("Authentication failed");
      }
    } catch (e) {
      print('Authentication error: $e');

      // Handle specific FragmentActivity error
      if (e is PlatformException && e.code == 'no_fragment_activity') {
        print("Critical error: MainActivity must extend FlutterFragmentActivity");
      }
    }
  }

  void changeDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void addStudent(Student student) {
    _firestoreService.addStudent(student);
  }

  void updateStudent(Student updatedStudent) {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
    }
  }

  void deleteStudent(String studentId) {
    _firestoreService.deleteStudent(studentId);
  }

}