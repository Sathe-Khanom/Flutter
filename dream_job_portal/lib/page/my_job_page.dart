import 'package:code/employer/jobApplicantsPage.dart';
import 'package:code/service/job_service.dart';
import 'package:flutter/material.dart';

import '../entity/job.dart';


class MyJobPage extends StatefulWidget {

  const MyJobPage({Key? key}) : super(key: key);

  @override
  State<MyJobPage> createState() => _MyJobPageState();
}

class _MyJobPageState extends State<MyJobPage> {
  late Future<List<Job>> _futureJobs;

  @override
  void initState() {
    super.initState();
    _futureJobs = JobService().getMyJobs(); // Call your service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posted Jobs"),
      ),
      body: FutureBuilder<List<Job>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You have not posted any jobs yet.'),
            );
          } else {
            final jobs = snapshot.data!;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(job.logo),
                    ),
                    title: Text(job.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.companyName),
                        Text('Salary: \$${job.salary.toStringAsFixed(2)}'),
                        Text('Posted: ${job.postedDate.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobApplicantsPage(jobId: job.id),
                        ),
                      );

                      // Navigate to job detail if needed
                    },
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
