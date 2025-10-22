import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/page/adminpage.dart';
import 'package:code/page/registrationpag.dart';
import 'package:code/service/authservice.dart';
import 'package:code/service/employer_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../employer/employer_profile.dart';
import 'job_list_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = FlutterSecureStorage();

  bool _obscurePassword = true;

  final AuthService authService = AuthService();
  final JobSeekerService jobSeekerService = JobSeekerService();
  final EmployerService employerService = EmployerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🎨 Gradient Background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔑 Title
                      Text(
                        'Login to Dream Job',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 30),

                      // 📧 Email Field
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                      SizedBox(height: 20),

                      // 🔒 Password Field
                      TextField(
                        controller: password,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                      SizedBox(height: 30),

                      // 🚀 Login Button
                      ElevatedButton(
                        onPressed: () {
                          loginUser(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // 📝 Register Text Button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registration()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔐 Login Logic (Unchanged)
  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);
      final role = await authService.getUserRole();

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminMainScreen()),
        );
      } else if (role == 'JOBSEEKER') {
        final profile = await jobSeekerService.getJobSeekerProfile();



        if (profile != null) {

          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('jobSeekerId', profile['id']);
          print('JobSeeker ID saved: ${profile['id']}');


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobSeekerProfile(profile: profile),
            ),
          );
        }
      } else if (role == 'EMPLOYER') {
        final employer = await employerService.getProfile();
        if (employer != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployerProfile(employer: employer),
            ),
          );
        }
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }
}
