import 'package:code/page/registrationpag.dart';
import 'package:flutter/material.dart';

import '../employer/employer_registration_page.dart';
import 'loginpage.dart';



// ================= MAIN SCREEN ====================
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    Center(child: Text('Company Page Coming Soon')),
    Center(child: Text('Contacts Page Coming Soon')),
    Center(child: Text('Recent Jobs Page Coming Soon')),
    Center(child: Text('Notifications Page Coming Soon')),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dream Job'),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Login', style: TextStyle(color: Colors.white)),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'job_seeker') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                );
              } else if (value == 'employer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployerRegistration()),
                );
              }
            },
            icon: Text('Register', style: TextStyle(color: Colors.white)),
            color: Colors.white,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'job_seeker',
                child: Text('As Job Seeker'),
              ),
              PopupMenuItem<String>(
                value: 'employer',
                child: Text('As Employer'),
              ),
            ],
          ),
        ],

      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.work, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Dream Job Portal',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Company'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contacts'),
              onTap: () => _selectPage(2),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Recent Jobs'),
              onTap: () => _selectPage(3),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () => _selectPage(4),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          CustomFooter(), // Footer at bottom of all pages
        ],
      ),
    );
  }
}

// ================= HOME TAB ====================
class HomeTab extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final List<Map<String, String>> jobList = [
    {
      'title': 'Flutter Developer',
      'company': 'TechSoft Inc.',
      'location': 'New York, NY',
    },
    {
      'title': 'UI/UX Designer',
      'company': 'Creative Minds',
      'location': 'San Francisco, CA',
    },
    {
      'title': 'Backend Engineer',
      'company': 'CodeWorks',
      'location': 'Seattle, WA',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Find Your Dream Job',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 20),

          // ========== SEARCH BAR ==========
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Job Category',
                    prefixIcon: Icon(Icons.work),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle search
                  print("Searching...");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: 30),

          // ========== JOB LISTINGS ==========
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Jobs',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(height: 10),

          ListView.builder(
            itemCount: jobList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final job = jobList[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.work, color: Colors.white),
                  ),
                  title: Text(
                    job['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${job['company']} • ${job['location']}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Handle tap
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================= FOOTER ====================
class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[50],
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.deepPurple, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2025 Dream Job. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.deepPurple),
              ),
              Row(
                children: [
                  Icon(Icons.facebook, size: 18, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Icon(Icons.linked_camera, size: 18, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Icon(Icons.email, size: 18, color: Colors.deepPurple),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
