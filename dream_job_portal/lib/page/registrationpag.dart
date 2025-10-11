import 'dart:io';
import 'package:code/page/loginpage.dart';
import 'package:code/service/authservice.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _obscurePassword = true;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final RadioGroupController genderController = RadioGroupController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;
  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Registration',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        SizedBox(height: 30),

                        // Full Name
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 20.0),

                        // Email
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20.0),

                        // Password
                        TextField(
                          obscureText: _obscurePassword,
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Confirm Password
                        TextField(
                          controller: confirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                        // Phone
                        TextField(
                          controller: cell,
                          decoration: InputDecoration(
                            labelText: 'Cell Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Address
                        TextField(
                          controller: address,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home),
                          ),
                        ),
                        SizedBox(height: 20),

                        // DOB
                        DateTimeFormField(
                          decoration:
                          const InputDecoration(labelText: 'Date of Birth'),
                          mode: DateTimeFieldPickerMode.date,
                          pickerPlatform: dob,
                          onChanged: (DateTime? value) {
                            setState(() {
                              selectedDOB = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        // Gender
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              v2.RadioGroup(
                                controller: genderController,
                                values: const ["Male", "Female", "Other"],
                                indexOfDefault: 2,
                                orientation:
                                RadioGroupOrientation.horizontal,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedGender = newValue.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),

                        // Image Picker
                        TextButton.icon(
                          icon: Icon(Icons.image),
                          label: Text('Upload Image'),
                          onPressed: pickImage,
                        ),
                        if (kIsWeb && webImage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              webImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (!kIsWeb && selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(selectedImage!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                        SizedBox(height: 30.0),

                        // Register Button
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          child: Text(
                            "Register",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20.0),

                        // Login Redirect
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      if (kIsWeb) {
        if (webImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select an image.')),
          );
          return;
        }
      } else {
        if (selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select an image.')),
          );
          return;
        }
      }

      final user = {
        "name": name.text,
        "email": email.text,
        "phone": cell.text,
        "password": password.text,
      };

      final jobSeeker = {
        "name": name.text,
        "email": email.text,
        "phone": cell.text,
        "gender": selectedGender ?? "Other",
        "address": address.text,
        "dateOfBirth": selectedDOB?.toIso8601String() ?? "",
      };

      final apiService = AuthService();
      bool success = false;

      if (kIsWeb && webImage != null) {
        success = await apiService.registerJobSeekerWeb(
          user: user,
          jobSeeker: jobSeeker,
          photoBytes: webImage!,
        );
      } else if (selectedImage != null) {
        success = await apiService.registerJobSeekerWeb(
          user: user,
          jobSeeker: jobSeeker,
          photoFile: File(selectedImage!.path),
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed')),
        );
      }
    }
  }
}
