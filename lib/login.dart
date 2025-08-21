import 'package:attendance_scanner/homepage.dart';
import 'package:attendance_scanner/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'student_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLecturer = true; // Default role is lecturer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Attendance Scanner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Role selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login as:'),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text('Lecturer', style: TextStyle(color: Colors.green),),
                    selected: _isLecturer,
                    onSelected: (selected) => setState(() => _isLecturer = selected),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Student',style: TextStyle(color: Colors.green),),
                    selected: !_isLecturer,
                    onSelected: (selected) => setState(() => _isLecturer = !selected),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('Forgot Password')
                ],
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(50, 40),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _isLecturer
                            ? const HomePage()
                            : const StudentHomeScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Login'),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(50, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}