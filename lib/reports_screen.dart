import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_provider.dart';
import 'student_model.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'By Student'),
              Tab(text: 'By Date'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSummaryTab(provider),
            _buildStudentTab(provider),
            _buildDateTab(provider),
          ],
        ),
      ),
    );
  }

  // reports_screen.dart (simplified)
  Widget _buildSummaryTab(AttendanceProvider provider) {
    return ListView.builder(
      itemCount: provider.students.length,
      itemBuilder: (context, index) {
        final student = provider.students[index];
        final percentage = (student.totalPresent / 30) * 100; // Assuming 30 classes

        return Card(
          child: ListTile(
            title: Text(student.name),
            subtitle: Text('${student.regNumber} - Present: ${student.totalPresent}/30'),
            trailing: CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                  percentage > 75 ? Colors.green : Colors.orange
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudentTab(AttendanceProvider provider) {
    return ListView(
      children: provider.students.map((student) {
        return ExpansionTile(
          title: Text(student.name),
          subtitle: Text(student.regNumber),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: student.attendance.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      color: entry.value ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDateTab(AttendanceProvider provider) {
    // Group attendance by date
    final Map<String, List<Student>> attendanceByDate = {};
    for (final student in provider.students) {
      for (final entry in student.attendance.entries) {
        if (entry.value) {
          attendanceByDate.putIfAbsent(entry.key, () => []).add(student);
        }
      }
    }

    return ListView(
      children: attendanceByDate.entries.map((entry) {
        return ExpansionTile(
          title: Text(entry.key),
          subtitle: Text('${entry.value.length} students present'),
          children: entry.value.map((student) {
            return ListTile(
              title: Text(student.name),
              subtitle: Text(student.regNumber),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}