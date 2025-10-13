import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting DateTime
import '../entity/job.dart';
import '../service/job_service.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({Key? key}) : super(key: key);

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  late Future<List<Job>> _futureJobs;

  @override
  void initState() {
    super.initState();
    _futureJobs = JobService().getAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Jobs'),
      ),
      body: FutureBuilder<List<Job>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          } else {
            final jobs = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final postedDate = DateFormat('MMM d, yyyy').format(job.postedDate);
                final endDate = job.endDate != null
                    ? DateFormat('MMM d, yyyy').format(job.endDate!)
                    : null;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Logo + Job Title
                        Row(
                          children: [
                            job.logo.isNotEmpty
                                ? Image.network(
                              'http://localhost:8085/images/employer/${job.logo}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.business, size: 60),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                job.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Company Info
                        Text(
                          job.companyName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text('Contact: ${job.contactPerson} • ${job.phone} • ${job.email}'),
                        if (job.companyWebsite.isNotEmpty)
                          Text('Website: ${job.companyWebsite}'),
                        const SizedBox(height: 8),

                        // Job Details
                        Text('Location: ${job.locationName}'),
                        Text('Category: ${job.categoryName}'),
                        Text('Type: ${job.jobType}'),
                        Text('Salary: \$${job.salary.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),

                        // Job Description & Optional Fields
                        Text('Description: ${job.description}'),
                        if (job.keyResponsibility != null)
                          Text('Responsibilities: ${job.keyResponsibility}'),
                        if (job.eduRequirement != null)
                          Text('Education Requirement: ${job.eduRequirement}'),
                        if (job.expRequirement != null)
                          Text('Experience Requirement: ${job.expRequirement}'),
                        if (job.benefits != null)
                          Text('Benefits: ${job.benefits}'),
                        const SizedBox(height: 8),

                        // Posted & End Date
                        Text('Posted on: $postedDate'),
                        if (endDate != null) Text('End Date: $endDate'),

                        SizedBox(height: 8),
                        // 👇 Bottom-right Apply Button
                         ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement apply functionality here
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Apply button pressed')),
                            );
                          },
                          icon: Icon(Icons.send,
                              color: Colors.white
                          ),
                          label: Text("Apply",
                          style: TextStyle(
                            color: Colors.white,)
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),



    );

  }
}
