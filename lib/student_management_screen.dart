import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_provider.dart';
import 'student_model.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Students')),
      body: ListView.builder(
        itemCount: provider.students.length,
        itemBuilder: (context, index) {
          final student = provider.students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.regNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditStudentDialog(context, student),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => provider.deleteStudent(student.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final regController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: regController,
              decoration: const InputDecoration(labelText: 'Registration Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<AttendanceProvider>(context, listen: false);
              provider.addStudent(
                Student(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  regNumber: regController.text,
                  courses: [], // Add empty courses list
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditStudentDialog(BuildContext context, Student student) {
    final nameController = TextEditingController(text: student.name);
    final regController = TextEditingController(text: student.regNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            TextField(controller: regController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<AttendanceProvider>(context, listen: false);
              provider.updateStudent(
                student.copyWith(
                  name: nameController.text,
                  regNumber: regController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}