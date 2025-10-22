import 'package:code/entity/employer.dart';
import 'package:code/page/homepage.dart';
import 'package:code/page/loginpage.dart';
import 'package:code/page/my_job_page.dart';
import 'package:flutter/material.dart';

import '../service/authservice.dart';
import 'add_job_page.dart';

class EmployerProfile extends StatelessWidget {
  final Employer? employer;

  const EmployerProfile({Key? key, this.employer}) : super(key: key);

  void onLogout(BuildContext context) {
    // Handle logout logic
    print("User logged out");
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Profile'),
        backgroundColor: Colors.blue.shade800,
      ),

      // ✅ Drawer for navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ✅ Company Logo and Name
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'http://localhost:8085/images/employer/${employer?.logo ?? 'default.png'}',
                ),
                backgroundColor: Colors.white,
              ),
              accountName: Text(employer?.companyName ?? 'Company Name'),
              accountEmail: const Text('Employer'),
            ),

            // ✅ Menu Items

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeTab()),
              )
              ,
            ),

            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('My Jobs'),
              onTap: () {
                Navigator.of(context).pop(); // close drawer first

                if (employer != null && employer!.id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyJobPage(),  // Use '!' here safely
                    ),
                  );
                } else {
                  // Handle null employer or null id
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employer or Employer ID not found!')),
                  );
                }
              },
            ),


            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Post New Job'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddJobForm()),
              )
              ,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile/edit'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                // Directly create an instance and call logout
                await AuthService().logout();

                // Optional: show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out')),
                );

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>LoginPage())
                );
              },
            ),
          ],
        ),
      ),

      // ✅ Body - Employer Details or Loading
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: employer != null
            ? Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              // ✅ Header (Unchanged)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(),
              ),

              // ✅ Body (UPDATED FOR VERTICAL LAYOUT)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column( // Main Column for vertical stacking
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. ✅ Logo and Basic Company Info (Top Section)
                    // ******************************************************
                    Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            'http://localhost:8085/images/employer/${employer!.logo}',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                            },
                          ),
                        ),
                        const SizedBox(height: 16), // Increased spacing after logo

                        Text(
                          employer!.companyName ?? 'Company Name',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18, // Slightly larger font for name
                          ),
                        ),
                        const SizedBox(height: 8),

                        Chip(
                          label: Text(
                            employer!.industryType ?? 'Industry',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                      children: [
                        _infoRow(Icons.person, "Contact Person", employer!.contactPerson),
                        _infoRow(Icons.email, "Email", employer!.email),
                        _infoRow(Icons.phone, "Phone", employer!.phoneNumber),
                        _infoRow(Icons.language, "Website", employer!.companyWebsite, isLink: true),
                      ],
                    ),
                    // ******************************************************
                  ],
                ),
              )
            ],
          ),
        )

        // ✅ Loading State
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Loading employer profile...",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper for info row
  Widget _infoRow(IconData icon, String label, String? value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: isLink
                ? InkWell(
              onTap: () {
                // TODO: launch URL
              },
              child: Text(
                value ?? '',
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                overflow: TextOverflow.ellipsis,
              ),
            )
                : Text(value ?? ''),
          ),
        ],
      ),
    );
  }
}
