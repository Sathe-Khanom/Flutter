import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/application_service.dart';
import 'package:code/service/apply_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';
import '../entity/job.dart';

class JobDetailsPage extends StatelessWidget {
  // final Job job;
  // final int jobId;
  // final int employerId;

  final Job job;




  const JobDetailsPage({
    Key? key,
    required this.job
  }): super(key: key);


  //apply method
  void applyJob(BuildContext context) async {
    final applyService = ApplyService();

    try {
      final response = await applyService.applyForJob(
        jobId: job.id,
        employerId: job.employerId,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have successfully applied for this job!')),
      );

      print('Application successful: ${response.body}');
    } catch (err) {
      print('Application failed: $err');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply. Please login first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Company logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'http://localhost:8085/images/employer/${job.logo}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Job Info
            _buildSectionTitle('Job Overview'),
            _buildInfoRow('Company', job.companyName),
            _buildInfoRow('Location', job.locationName),
            _buildInfoRow('Category', job.categoryName),
            _buildInfoRow('Salary', '\$${job.salary.toStringAsFixed(2)}'),
            _buildInfoRow('Job Type', job.jobType),
            _buildInfoRow('Posted Date', job.postedDate.toLocal().toString().split(' ')[0]),
            if (job.endDate != null)
              _buildInfoRow('Deadline', job.endDate!.toString().split(' ')[0]),

            const SizedBox(height: 12),
            _buildSectionTitle('Description'),
            Text(job.description),

            const SizedBox(height: 12),
            if (job.keyResponsibility != null) ...[
              _buildSectionTitle('Key Responsibilities'),
              Text(job.keyResponsibility!),
              const SizedBox(height: 12),
            ],
            if (job.eduRequirement != null) ...[
              _buildSectionTitle('Educational Requirements'),
              Text(job.eduRequirement!),
              const SizedBox(height: 12),
            ],
            if (job.expRequirement != null) ...[
              _buildSectionTitle('Experience Requirements'),
              Text(job.expRequirement!),
              const SizedBox(height: 12),
            ],
            if (job.benefits != null) ...[
              _buildSectionTitle('Benefits'),
              Text(job.benefits!),
              const SizedBox(height: 12),
            ],

            const Divider(thickness: 1),
            _buildSectionTitle('Employer Info'),
            _buildInfoRow('Contact Person', job.contactPerson),
            _buildInfoRow('Email', job.email),
            _buildInfoRow('Phone', job.phone),
            _buildInfoRow('Website', job.companyWebsite),

            const SizedBox(height: 24),

            // 🔻 Apply Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  applyJob(context);

                  final profile = await JobSeekerService().getJobSeekerProfile();
                  if (profile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobSeekerProfile(profile: profile),
                      ),
                    );
                  }
                },

                icon: Icon(Icons.send, color: Colors.white),
                label: Text(
                  'Apply Now',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),


            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 15),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }





}
