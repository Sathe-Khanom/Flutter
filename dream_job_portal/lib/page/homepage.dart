import 'package:code/employer/employer_profile.dart';
import 'package:code/page/contact_page.dart';
import 'package:code/page/job_list_page.dart';
import 'package:code/service/authservice.dart';
import 'package:code/service/employer_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';
import 'package:code/entity/category.dart';
import 'package:code/entity/job.dart';
import 'package:code/entity/location.dart';
import 'package:code/page/job_card.dart';
import 'package:code/service/category_service.dart';
import 'package:code/service/job_service.dart';
import 'package:code/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../employer/employer_registration_page.dart';
import '../jobseeker/job_seeker_profile.dart';
import 'company_page.dart';
import 'registrationpag.dart';
import 'loginpage.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

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

  // --- Navigation Logic for Profile Card ---
  Future<void> _navigateToProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole');
    Widget? nextPage;

    if (role == 'ADMIN') {
      nextPage = const JobListPage();
    } else if (role == 'JOBSEEKER') {
      final profile = await JobSeekerService().getJobSeekerProfile();
      if (profile != null) {
        nextPage = JobSeekerProfile(profile: profile);
      }
    } else if (role == 'EMPLOYER') {
      final employer = await EmployerService().getProfile();
      if (employer != null) {
        nextPage = EmployerProfile(employer: employer);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login or register to view profile.')),
      );
      return; // Stop navigation if no role is found or profile is missing
    }

    if (nextPage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
    }
  }

  // --- Reusable Card Widget Builder ---
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 100,
        // Responsive 2-column layout (minus padding/spacing)
        width: MediaQuery.of(context).size.width / 2 - 25,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
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
              _navigateTo(context,  LoginPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService().logout(); // call the method
              // After logout, navigate to login page
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginPage()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
          ),
        ],
      ),
      // Drawer is intentionally omitted here

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ========= NAVIGATION CARDS SECTION (Replaces Drawer Navigation) =========
            Container(
              padding: const EdgeInsets.all(10), // Reduced padding slightly
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepPurple.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade50.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // Use a Column to stack the two rows
              child: Column(
                children: [
                  // --- First Row (3 cards) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Profile
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5), // Spacing between cards
                          child: _buildFeatureCard(
                            icon: Icons.account_circle,
                            title: 'My Profile',
                            color: Colors.deepPurple.shade600,
                            onTap: _navigateToProfile,
                          ),
                        ),
                      ),
                      // 2. Company
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _buildFeatureCard(
                            icon: Icons.business,
                            title: 'Companies',
                            color: Colors.blue.shade600,
                            onTap: () => _navigateTo(context, JobsByCompanyScreen()),
                          ),
                        ),
                      ),
                      // 3. Contact
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _buildFeatureCard(
                            icon: Icons.contact_mail,
                            title: 'Contact Us',
                            color: Colors.teal.shade600,
                            onTap: () => _navigateTo(context, ContactFormScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10), // Vertical spacing between rows

                  // --- Second Row (3 cards) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 4. Jobs (Browse Jobs)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _buildFeatureCard(
                            icon: Icons.work,
                            title: 'Browse Jobs',
                            color: Colors.orange.shade600,
                            onTap: () => loadAllJobs(),
                          ),
                        ),
                      ),
                      // 5. Job Seeker Registration
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _buildFeatureCard(
                            icon: Icons.person_add,
                            title: 'Job Seeker Reg.',
                            color: Colors.green.shade600,
                            onTap: () => _navigateTo(context, const Registration()),
                          ),
                        ),
                      ),
                      // 6. Employer Registration
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _buildFeatureCard(
                            icon: Icons.business_center,
                            title: 'Employer Reg.',
                            color: Colors.red.shade600,
                            onTap: () => _navigateTo(context, const EmployerRegistration()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Find Your Dream Job',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),



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

            const SizedBox(height: 20),

            // ========= JOB LIST =========
            jobs.isEmpty
                ? const Center(
              child: Text(
                'No jobs found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
