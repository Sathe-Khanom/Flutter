import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data
  List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "IT"},
    {"id": 2, "name": "Finance"},
  ];

  List<Map<String, dynamic>> locations = [
    {"id": 1, "name": "New York"},
    {"id": 2, "name": "San Francisco"},
  ];

  List<Map<String, dynamic>> jobs = [];

  int? selectedCategoryId;
  int? selectedLocationId;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  void loadJobs() {
    // You would replace this with your actual API call.
    setState(() {
      jobs = [
        {
          "id": 1,
          "title": "Flutter Developer",
          "locationName": "New York",
          "salary": 80000,
          "jobType": "Full-time",
          "postedDate": DateTime.now().subtract(Duration(days: 2)),
          "endDate": DateTime.now().add(Duration(days: 28)),
          "companyName": "Tech Corp",
          "contactPerson": "John Doe",
          "email": "hr@techcorp.com",
          "phone": "123-456-7890",
          "companyWebsite": "https://techcorp.com",
          "logo": "techcorp.png"
        }
      ];
    });
  }

  void filterJobs() {
    // Handle job filtering based on selectedCategoryId and selectedLocationId
    print("Filtering jobs with category: $selectedCategoryId and location: $selectedLocationId");
    // Simulated filter (replace with backend filter logic)
    loadJobs(); // Reload jobs (simulated)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Find Your Dream Job Today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Search from thousands of jobs, updated daily. Start your career journey now.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Search Form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int?>(
                            value: selectedCategoryId,
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text("All Categories"),
                              ),
                              ...categories.map((cat) => DropdownMenuItem<int?>(
                                value: cat['id'],
                                child: Text(cat['name']),
                              )),
                            ],
                            onChanged: (val) {
                              setState(() => selectedCategoryId = val);
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Category",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int?>(
                            value: selectedLocationId,
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text("All Locations"),
                              ),
                              ...locations.map((loc) => DropdownMenuItem<int?>(
                                value: loc['id'],
                                child: Text(loc['name']),
                              )),
                            ],
                            onChanged: (val) {
                              setState(() => selectedLocationId = val);
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Location",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: filterJobs,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: const Text("Search"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              color: Colors.red.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    "Why Choose Dream Job?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.work,
                        color: Colors.blue,
                        title: "Verified Listings",
                        description: "All jobs are verified from trusted companies for genuine opportunities.",
                        bgColor: Colors.blue.withOpacity(0.2),
                      ),
                      _buildFeatureCard(
                        icon: Icons.business_center,
                        color: Colors.green,
                        title: "Top Companies",
                        description: "Connect with top-tier employers across the country and abroad.",
                        bgColor: Colors.indigo.withOpacity(0.2),
                      ),
                      _buildFeatureCard(
                        icon: Icons.bolt,
                        color: Colors.orange,
                        title: "Instant Alerts",
                        description: "Get instant email alerts for your preferred job categories.",
                        bgColor: Colors.green.withOpacity(0.2),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Job Listings
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    "Here are your jobs..",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (jobs.isEmpty)
                    const Text("No jobs available.", style: TextStyle(color: Colors.grey)),
                  ...jobs.map((job) => _buildJobCard(job)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFFF0F8FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Job Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Location: ${job['locationName']}"),
                      Text("Salary: \$${job['salary']}"),
                      Text("Type: ${job['jobType']}"),
                      Text("Posted: ${_formatDate(job['postedDate'])}"),
                      Text("Deadline: ${_formatDate(job['endDate'])}"),
                      const Divider(),
                      const Text("Employer Info", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Company: ${job['companyName']}"),
                      Text("Contact: ${job['contactPerson']}"),
                      Text("Email: ${job['email']}"),
                      Text("Phone: ${job['phone']}"),
                      GestureDetector(
                        onTap: () {
                          // open website
                        },
                        child: Text(
                          job['companyWebsite'],
                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Logo
                Image.network(
                  "http://localhost:8085/images/employer/${job['logo']}",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // View Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to job detail
                  Navigator.pushNamed(context, '/jobs/${job['id']}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("View"),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
