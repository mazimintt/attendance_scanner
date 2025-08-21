import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);
    final currentDate = provider.selectedDate;
    final formattedDate = DateFormat('EEE, MMM d').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Attendance'),
        actions: [
          // Show warning icon if biometrics unavailable
          if (!provider.isBiometricAvailable)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.warning, color: Colors.orange),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Show warning banner if biometrics unavailable
          if (!provider.isBiometricAvailable)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.orange,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Biometrics not available on this device',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          _buildDateHeader(formattedDate),
          _buildAttendanceTable(context, provider, currentDate),
        ],
      ),
      floatingActionButton:
          !provider.isBiometricAvailable
              ? FloatingActionButton(
                onPressed: () => _showBiometricWarning(context),
                backgroundColor: Colors.orange,
                child: const Icon(Icons.warning),
              )
              : null,
    );
  }

  Widget _buildDateHeader(String formattedDate) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 20),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(
    BuildContext context,
    AttendanceProvider provider,
    DateTime currentDate,
  ) {
    final dateKey = DateFormat('yyyy-MM-dd').format(currentDate);

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Name')),
            const DataColumn(label: Text('Reg No')),
            const DataColumn(label: Text('Today')),
            const DataColumn(label: Text('Total')),
            const DataColumn(label: Text('Scan')),
          ],
          rows:
              provider.students.map((student) {
                final isPresent = student.attendance[dateKey] ?? false;

                return DataRow(
                  cells: [
                    DataCell(Text(student.name)),
                    DataCell(Text(student.regNumber)),
                    DataCell(_AttendanceBox(isPresent)),
                    DataCell(Text('${student.totalPresent}')),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.fingerprint),
                        color:
                            provider.isBiometricAvailable
                                ? Colors.blue
                                : Colors.grey,
                        onPressed: () async {
                          if (!provider.isBiometricAvailable) {
                            _showBiometricWarning(context);
                            return;
                          }

                          try {
                            await provider.markAttendance(student.id);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.toString()}")),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: provider.selectedDate,
              selectedDayPredicate:
                  (day) => isSameDay(day, provider.selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                provider.changeDate(selectedDay);
                Navigator.pop(context);
              },
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
          ),
    );
  }

  void _showBiometricWarning(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Biometrics Unavailable'),
            icon: const Icon(Icons.warning, color: Colors.orange, size: 48),
            content: const Text(
              'This device does not support biometric authentication. '
              'Attendance will be marked without verification.',
              textAlign: TextAlign.center,
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

class _AttendanceBox extends StatelessWidget {
  final bool isPresent;

  const _AttendanceBox(this.isPresent);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: isPresent ? Colors.green : Colors.transparent,
      ),
      child:
          isPresent
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
    );
  }
}
