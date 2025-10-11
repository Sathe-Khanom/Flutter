
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import '../page/loginpage.dart';
import '../service/authservice.dart';
import '../service/employer_service.dart';

class EmployerRegistration extends StatefulWidget {
  const EmployerRegistration({Key? key}) : super(key: key);

  @override
  State<EmployerRegistration> createState() => _EmployerRegistrationState();
}

class _EmployerRegistrationState extends State<EmployerRegistration> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers for User Info
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Controllers for Employer Info
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController companyWebsiteController = TextEditingController();
  final TextEditingController industryTypeController = TextEditingController();

  bool _obscurePassword = true;

  XFile? selectedImage;
  Uint8List? webImage;

  final EmployerService _employerService = EmployerService();

  String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employer Registration', style: GoogleFonts.lato()),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Contact Person
                TextFormField(
                  controller: contactPersonController,
                  decoration: InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter contact person' : null,
                ),
                SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) return 'Enter valid email';
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter phone number' : null,
                ),
                SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) =>
                  value == null || value.length < 6 ? 'Minimum 6 chars' : null,
                ),
                SizedBox(height: 25),

                // Employer Info Section
                Text(
                  "Employer Information",
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 15),

                // Company Name
                TextFormField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter company name' : null,
                ),
                SizedBox(height: 15),

                // Company Address
                TextFormField(
                  controller: companyAddressController,
                  decoration: InputDecoration(
                    labelText: 'Company Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter address' : null,
                ),
                SizedBox(height: 15),

                // Company Website
                TextFormField(
                  controller: companyWebsiteController,
                  decoration: InputDecoration(
                    labelText: 'Company Website',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.web),
                  ),
                ),
                SizedBox(height: 15),

                // Industry Type
                TextFormField(
                  controller: industryTypeController,
                  decoration: InputDecoration(
                    labelText: 'Industry Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 25),

                // Image Picker
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.upload_file),
                  label: Text('Upload Company Logo'),
                ),
                SizedBox(height: 10),

                if (kIsWeb && webImage != null)
                  Image.memory(webImage!, height: 100, width: 100, fit: BoxFit.cover)
                else if (!kIsWeb && selectedImage != null)
                  Image.file(File(selectedImage!.path),
                      height: 100, width: 100, fit: BoxFit.cover),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _registerEmployer,
                  child: Text('Register', style: GoogleFonts.lato(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                if (message != null) ...[
                  SizedBox(height: 20),
                  Text(
                    message!,
                    style: TextStyle(
                      color: message!.toLowerCase().contains('success')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      final pickedBytes = await ImagePickerWeb.getImageAsBytes();
      if (pickedBytes != null) {
        setState(() {
          webImage = pickedBytes;
          selectedImage = null;
        });
      }
    } else {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = pickedFile;
          webImage = null;
        });
      }
    }
  }

  Future<void> _registerEmployer() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        message = "Please fill all required fields correctly.";
      });
      return;
    }

    if (kIsWeb && webImage == null) {
      setState(() {
        message = "Please upload a company logo.";
      });
      return;
    }

    if (!kIsWeb && selectedImage == null) {
      setState(() {
        message = "Please upload a company logo.";
      });
      return;
    }

    // Prepare data maps
    final user = {
      "contactPerson": contactPersonController.text.trim(),
      "email": emailController.text.trim(),
      "phoneNumber": phoneController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final employer = {
      "companyName": companyNameController.text.trim(),
      "companyAddress": companyAddressController.text.trim(),
      "companyWebsite": companyWebsiteController.text.trim(),
      "industryType": industryTypeController.text.trim(),
    };

    try {
      final apiService = AuthService();
      bool success = false;

      if (kIsWeb && webImage != null) {
        // Send bytes on web
        success = await _employerService.registerEmployerWeb(
          user: user,
          employer: employer,
          photoBytes: webImage!,
        );
      } else if (selectedImage != null) {
        // Send file on mobile
        success = await _employerService.registerEmployer(
          user: user,
          employer: employer,
          logo: File(selectedImage!.path),
        );
      } else {
        setState(() {
          message = "Please upload a company logo.";
        });
        return;
      }

      if (success) {
        setState(() {
          message = "Registration successful!";
        });

        // Optionally navigate to login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        setState(() {
          message = "Registration failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        message = "Error: $e";
      });
    }
  }

  @override
  void dispose() {
    contactPersonController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    companyWebsiteController.dispose();
    industryTypeController.dispose();
    super.dispose();
  }
}
