// student_model.dart
import 'course_model.dart';

class Student {
  final String id;
  final String name;
  final String regNumber;
  final Map<String, bool> attendance;
  int get totalPresent => attendance.values.where((isPresent) => isPresent).length;
  final List<Course> courses;

  Student({
    required this.id,
    required this.name,
    required this.regNumber,
    Map<String, bool>? attendance,
    required this.courses,
  }) :
        attendance = attendance ?? {};

  Student copyWith({
    String? id,
    String? name,
    String? regNumber,
    Map<String, bool>? attendance,
    List<Course>? courses,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      regNumber: regNumber ?? this.regNumber,
      attendance: attendance ?? this.attendance,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'regNumber': regNumber,
      'attendance': attendance,
      'courses': courses.map((course) => course.toMap()).toList(),
    };
  }
}