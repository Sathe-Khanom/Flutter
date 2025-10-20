import 'package:code/entity/ApplyDTO.dart';
import 'package:code/service/apply_service.dart';
import 'package:flutter/material.dart';


class JobApplicantsPage extends StatefulWidget {
  final int jobId;


  const JobApplicantsPage({required this.jobId});

  @override
  State<JobApplicantsPage> createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  late Future<List<ApplyDTO>> _applications;

  @override
  void initState() {
    super.initState();
    _applications = ApplyService().getApplicationsForJob(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applicants")),
      body: FutureBuilder<List<ApplyDTO>>(
        future: _applications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final applicants = snapshot.data ?? [];
          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final app = applicants[index];
              return ListTile(
                title: Text(app.jobSeekerName),
                subtitle: Text(app.jobTitle),
                onTap: () {
                  // navigate to detailed CV page if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
