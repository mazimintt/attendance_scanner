import 'package:attendance_scanner/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_scanner/student_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add student
  Future<void> addStudent(Student student) async {
    try {
      await _firestore.collection('students').doc(student.id).set({
        'name': student.name,
        'regNumber': student.regNumber,
        'attendance': student.attendance,
        'courses': student.courses.map((course) => course.toMap()).toList(),
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Get students stream
  Stream<List<Student>> getStudents() {
    return _firestore.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student(
          id: doc.id,
          name: data['name'],
          regNumber: data['regNumber'],
          attendance: Map<String, bool>.from(data['attendance'] ?? {}),
          courses: (data['courses'] as List<dynamic>?)
              ?.map((courseData) => Course.fromMap(courseData))
              .toList() ??
              [],
        );
      }).toList();
    });
  }

  // Update student attendance
  Future<void> updateAttendance(
      String studentId, Map<String, bool> attendance) async {
    try {
      await _firestore
          .collection('students')
          .doc(studentId)
          .update({'attendance': attendance});
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Delete student
  Future<void> deleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}