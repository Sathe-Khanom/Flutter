import 'package:flutter/material.dart';

import '../entity/job.dart';
import '../service/job_service.dart';
import 'job_details.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF0F8FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job info section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.locationName),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Salary: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '\$${job.salary.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.jobType),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Posted: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '${job.postedDate.toLocal().toString().split(' ')[0]}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Deadline: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '${job.endDate.toString().split(' ')[0]}'),
                          ],
                        ),
                      ),
                      Divider(height: 20, thickness: 1),
                      Text(
                        'Employer Info',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Company: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.companyName),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Contact: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.contactPerson),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.email),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: 'Phone: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: job.phone),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.blue),
                          children: [
                            TextSpan(text: 'Website: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () {
                                  // Use url_launcher to open website
                                },
                                child: Text(
                                  job.companyWebsite,
                                  style: TextStyle(decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // Logo on right
                ClipRRect(
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
              ],
            ),

            SizedBox(height: 12),

            // View button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final jobDetails = await JobService().getJobById(job.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailsPage(job: jobDetails),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to load job details')),
                      );
                    }
                  },
                  child: Text(
                    'View',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 14),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
