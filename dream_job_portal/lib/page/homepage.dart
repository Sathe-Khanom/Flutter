import 'package:code/page/contact_page.dart';
import 'package:code/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:code/entity/category.dart';
import 'package:code/entity/job.dart';
import 'package:code/entity/location.dart';
import 'package:code/page/job_card.dart';
import 'package:code/service/category_service.dart';
import 'package:code/service/job_service.dart';
import 'package:code/service/location_service.dart';
import '../employer/employer_registration_page.dart';
import 'company_page.dart';
import 'registrationpag.dart';
import 'loginpage.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int? selectedCategoryId;
  int? selectedLocationId;
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    loadAllJobs();
  }

  Future<void> loadAllJobs() async {
    final allJobs = await JobService().getAllJobs();
    setState(() {
      jobs = allJobs;
    });
  }

  Future<void> filterJobs() async {
    try {
      final filteredJobs = await JobService().searchJobs(
        categoryId: selectedCategoryId,
        locationId: selectedLocationId,
      );
      setState(() {
        jobs = filteredJobs;
      });
    } catch (e) {
      debugPrint('Error filtering jobs: $e');
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          'Dream Job Portal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Login',
            onPressed: () {
              _navigateTo(context, LoginPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService().logout(); // call the method
              // After logout, navigate to login page
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out')),
              );
            },
          ),
        ],
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                'Dream Job Portal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),


            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Company'),
              onTap: () {
                _navigateTo(context, JobsByCompanyScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact'),
              onTap: () {
                _navigateTo(context, ContactFormScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Jobs'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Add notifications page navigation
              },
            ),

            Divider(),

            /// ✅ Registration dropdown menu
            ExpansionTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Job Seeker Registration'),
                  onTap: () {
                    _navigateTo(context, Registration());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.business_center),
                  title: Text('Employer Registration'),
                  onTap: () {
                    _navigateTo(context, EmployerRegistration());
                  },
                ),
              ],
            ),
          ],
        ),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Find Your Dream Job',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),

            // ========= FILTER ROW =========
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Location Dropdown =====
                SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<Location>>(
                    future: LocationService().getAllLocations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Error loading locations');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No locations found');
                      } else {
                        final locations = snapshot.data!;
                        final validValue = locations.any((loc) => loc.id == selectedLocationId)
                            ? selectedLocationId
                            : null;

                        return DropdownButtonFormField<int>(
                          value: validValue,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                          items: locations.map((loc) {
                            return DropdownMenuItem<int>(
                              value: loc.id,
                              child: Text(loc.name),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() => selectedLocationId = newValue);
                          },
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ===== Category Dropdown =====
                SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<Category>>(
                    future: CategoryService().getAllCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Error loading categories');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No categories found');
                      } else {
                        final categories = snapshot.data!;
                        final validValue = categories.any((cat) => cat.id == selectedCategoryId)
                            ? selectedCategoryId
                            : null;

                        return DropdownButtonFormField<int>(
                          value: validValue,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category),
                            border: OutlineInputBorder(),
                          ),
                          items: categories.map((cat) {
                            return DropdownMenuItem<int>(
                              value: cat.id,
                              child: Text(cat.name),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() => selectedCategoryId = newValue);
                          },
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ===== Search Button =====
                ElevatedButton.icon(
                  onPressed: filterJobs,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    "Search",
                    style: TextStyle(color: Colors.white), // text color
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // ========= JOB LIST =========
            jobs.isEmpty
                ? Center(
              child: Text(
                'No jobs found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return JobCard(job: jobs[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
