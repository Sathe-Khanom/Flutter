import 'package:code/entity/category.dart';
import 'package:code/entity/job.dart';
import 'package:code/entity/location.dart';
import 'package:code/page/registrationpag.dart';
import 'package:code/service/category_service.dart';
import 'package:code/service/job_service.dart';
import 'package:code/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:code/page/job_card.dart';
import 'package:code/entity/job.dart';

import '../employer/employer_registration_page.dart';
import 'loginpage.dart';

// ================= MAIN SCREEN ====================
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late Future<List<Job>> _jobsFuture;

  List<Location> locations = [];
  late Location selectedLocation;
  bool isLoading = true;


  //for categoty
  List<Category> categories = [];
  late Category selectedCategory;
  bool loading = true;


  int _selectedIndex = 0;

  //category

  @override
  void initState() {
    super.initState();
    loadLocations();
    loadCategories();
    _jobsFuture = JobService().getAllJobs();
  }

  Future<void> loadLocations() async {
    try {
      locations = await LocationService().getAllLocations();
      if (locations.isNotEmpty) {
        selectedLocation = locations.first; // optional: select first by default
      }
    } catch (e) {
      debugPrint('Error loading locations: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //category

  Future<void> loadCategories() async {
    try {
      categories = await CategoryService().getAllCategories();
      if (categories.isNotEmpty) {
        selectedCategory = categories.first; // optional: select first by default
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  late final List<Widget> _pages = [
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
                  MaterialPageRoute(
                    builder: (context) => EmployerRegistration(),
                  ),
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
              decoration: BoxDecoration(color: Colors.deepPurple),
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
              // ---------- LOCATION DROPDOWN ----------
              Expanded(
                flex: 2, // takes 2 parts of available width
                child: FutureBuilder<List<Location>>(
                  future: LocationService().getAllLocations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading locations');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No locations found');
                    } else {
                      List<Location> locations = snapshot.data!;
                      Location? selectedLocation = locations.first; // default

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButtonFormField<Location>(
                            value: selectedLocation,
                            decoration: InputDecoration(
                              labelText: 'Location',
                              prefixIcon: Icon(Icons.location_on),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            items: locations.map((loc) {
                              return DropdownMenuItem<Location>(
                                value: loc,
                                child: Text(loc.name),
                              );
                            }).toList(),
                            onChanged: (Location? newValue) {
                              setState(() {
                                selectedLocation = newValue;
                                locationController.text = newValue!
                                    .name; // update controller if needed
                              });
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              SizedBox(width: 10),

              // ---------- JOB CATEGORY dropdown----------
              Expanded(
                flex: 2, // takes 2 parts of available width
                child: FutureBuilder<List<Category>>(
                  future: CategoryService().getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading categories');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No categories found');
                    } else {
                      List<Category> categories = snapshot.data!;
                      Category? selectedCategory = categories.first; // default

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButtonFormField<Category>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.ac_unit_sharp),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            items: categories.map((loc) {
                              return DropdownMenuItem<Category>(
                                value: loc,
                                child: Text(loc.name),
                              );
                            }).toList(),
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                                categoryController.text = newValue!
                                    .name; // update controller if needed
                              });
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),

            ],
          ),

          SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {

            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),

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
            'Here are your jobs..',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ),

        SizedBox(height: 10),

        FutureBuilder<List<Job>>(
          future: _jobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading jobs: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: EdgeInsets.all(20),
                color: Colors.blue.shade100,
                child: Center(
                  child: Text(
                    'No jobs available.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  ),
                ),
              );
            } else {
              final jobs = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(job: job);
                },
              );
            }
          },
        ),
        SizedBox(height: 30),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
