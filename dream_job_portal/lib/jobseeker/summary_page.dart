import 'package:code/jobseeker/edit_JobSeeker_Summary.dart';
import 'package:flutter/material.dart';

class JobSeekerSummary extends StatefulWidget {
  Map<String, dynamic>? summary;

  JobSeekerSummary({super.key, required this.summary});

  @override
  _JobSeekerSummaryState createState() => _JobSeekerSummaryState();
}

class _JobSeekerSummaryState extends State<JobSeekerSummary> {
  @override
  Widget build(BuildContext context) {
    if (widget.summary == null) {
      return const Scaffold(
        body: Center(child: Text('No summary data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker Summary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedSummary = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditJobSeekerSummary(summary: widget.summary),
                ),
              );

              if (updatedSummary != null) {
                setState(() {
                  widget.summary = updatedSummary;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Description Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.summary!['description'] ?? 'No description available',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Personal Info Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    infoRow('Father', widget.summary!['fatherName']),
                    infoRow('Mother', widget.summary!['motherName']),
                    infoRow('Nationality', widget.summary!['nationality']),
                    infoRow('Religion', widget.summary!['religion']),
                    infoRow('Blood Group', widget.summary!['bloodGroup']),
                    infoRow('Height', widget.summary!['height']),
                    infoRow('Weight', widget.summary!['weight']),
                    infoRow('NID', widget.summary!['nid']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                '$title:',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87),
              )),
          Expanded(
              flex: 5,
              child: Text(
                value ?? 'N/A',
                style: const TextStyle(color: Colors.black54),
              )),
        ],
      ),
    );
  }
}
