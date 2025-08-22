import 'package:attendance_scanner/course_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_provider.dart';
import 'student_model.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<AttendanceProvider>(context).students;

    // Check if students list is empty
    if (students.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Student Dashboard'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    // For simplicity, we'll use the first student as the logged-in student
    final currentStudent = students.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentInfo(currentStudent),
            const SizedBox(height: 20),
            const Text(
              'Course Attendance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildCourseList(currentStudent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfo(Student student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('ID: ${student.regNumber}'),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCourseList(Student student) {
    return ListView.builder(
      itemCount: student.courses.length,
      itemBuilder: (context, index) {
        final course = student.courses[index];
        final missed = course.missed;

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text('${course.code} - ${course.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text('Attended: ${course.attended}/${course.total} classes'),
                if (missed > 0) ...[
                  const SizedBox(height: 5),
                  Text(
                    'Missed: $missed classes',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
            trailing: Chip(
              label: Text('${course.percentage.toStringAsFixed(1)}%'),
              backgroundColor: course.percentage > 75
                  ? Colors.green[100]
                  : Colors.orange[100],
            ),
            onTap: () {
              _showCourseDetails(context, course);
            },
          ),
        );
      },
    );
  }

  void _showCourseDetails(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${course.code} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text('Attendance: ${course.attended}/${course.total} (${course.percentage.toStringAsFixed(1)}%)'),
            const SizedBox(height: 10),
            if (course.missed > 0)
              Text(
                'You missed ${course.missed} classes',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 15),
            const Text(
              'Please contact your lecturer to discuss any missed classes.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}