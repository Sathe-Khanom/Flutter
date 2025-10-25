import 'package:code/entity/ApplyDTO.dart';
import 'package:code/jobseeker/cv_generator.dart';
import 'package:code/service/apply_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';


// JobSeeker entity-র জন্য প্রয়োজনীয় ইমপোর্ট
import '../entity/jobSeeker.dart';


class JobApplicantsPage extends StatefulWidget {
  final int jobId;

  const JobApplicantsPage({required this.jobId, super.key});

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

  // CV Download Logic Method
  void _downloadCV(int id, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating CV... Please wait.')),
    );
    try {
      // Step 1: ApplyDTO-কে CV Generator-এর জন্য উপযোগী Map Format-এ কনভার্ট করুন।
      // এখানে সরাসরি হেল্পার ফাংশন কল করা হয়েছে


      // This must be inside an async function
      final jsonData = await JobSeekerService().getFullJobSeekerProfile(id);

      if (jsonData != null) {
        final Map<String, dynamic> profileData = convertFullJobSeekerJsonToProfileMap(jsonData);

        // Now you can use profileData for CV generation
        await generateAndPrintCV(profileData);
      }


      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV generation complete!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Ensure error 'e' is displayed as a String
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download CV: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applicants")),
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
                leading: const Icon(Icons.person, size: 40, color: Colors.blue),
                title: Text(
                  app.jobSeekerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.jobTitle),
                    const SizedBox(height: 4),
                    Text("Email: ${app.email}"),
                    Text("Phone: ${app.phone} "),

                  ],
                ),
                // CV Download Button
                trailing: SizedBox(
                  width: 130,
                  child: ElevatedButton.icon(

                    onPressed: () {

                      _downloadCV(app.jobSeekerId, context);
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.white),
                    label: const Text(
                      "Download CV",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
                ),
                onTap: () {
                  // Navigate to detailed CV page
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------------------------------
// HELPER FUNCTION (placed outside the class)
// ------------------------------------------------

// Helper Function: ApplyDTO থেকে CV Generator-এর জন্য উপযোগী Map তৈরি করা
Map<String, dynamic> _convertApplyDTOToProfileMap(ApplyDTO dto) {
  final JobSeeker? js = dto.jobSeeker;

  // If JobSeeker object (js) is null, return basic info and empty lists
  if (js == null) {
    return {
      'name': dto.jobSeekerName,
      'phone': dto.phone,
      'user': {'email': dto.email},
      'address': 'N/A',
      'photo': null,
      'dateOfBirth': 'N/A',
      'gender': 'N/A',
      'summery': [],
      'educations': [],
      'experiences': [],
      'skills': [],
      'trainings': [],
      'extracurriculars': [],
      'languages': [],
      'hobbies': [],
      'refferences': [],
    };
  }

  // If JobSeeker object (js) is available, use its detailed data
  final summaryList = js.summary.map((s) => s.toJson()).toList();

  return {
    // Basic Profile Info
    'name': js.name.isNotEmpty ? js.name : dto.jobSeekerName,
    'phone': js.phone.isNotEmpty ? js.phone : dto.phone,
    'user': {'email': js.user.email.isNotEmpty ? js.user.email : dto.email},
    'address': js.address,
    'photo': js.photo,
    'dateOfBirth': js.dateOfBirth,
    'gender': js.gender,

    // Nested Entities (Converted to List of Maps using .toJson())
    'summery': summaryList,
    'educations': js.educations.map((e) => e.toJson()).toList(),
    'experiences': js.experiences.map((e) => e.toJson()).toList(),
    'skills': js.skills.map((e) => e.toJson()).toList(),
    'trainings': js.trainings.map((e) => e.toJson()).toList(),
    'extracurriculars': js.extracurriculars.map((e) => e.toJson()).toList(),
    'languages': js.languages.map((e) => e.toJson()).toList(),
    'hobbies': js.hobbies.map((e) => e.toJson()).toList(),
    // CV generator expects 'refferences'
    'refferences': js.references.map((e) => e.toJson()).toList(),
  };
}


Map<String, dynamic> convertFullJobSeekerJsonToProfileMap(Map<String, dynamic> json) {
  // Take the first summary object if exists
  final summary = (json['summeries'] != null && (json['summeries'] as List).isNotEmpty)
      ? json['summeries'][0]
      : {};

  return {
    'name': json['name'] ?? 'N/A',
    'phone': json['phone'] ?? 'N/A',
    'user': {
      'email': json['email'] ?? 'N/A',
    },
    'address': json['address'] ?? 'N/A',
    'photo': json['photo'],
    'dateOfBirth': json['dateOfBirth'] ?? 'N/A',
    'gender': json['gender'] ?? 'N/A',
    'summery': summary != null ? [summary] : [],
    'educations': json['educations'] ?? [],
    'experiences': json['experiences'] ?? [],
    'skills': json['skills'] ?? [],
    'trainings': json['trainings'] ?? [],
    'extracurriculars': json['extracurriculars'] ?? [],
    'languages': json['languages'] ?? [],
    'hobbies': json['hobbies'] ?? [],
    'refferences': json['references'] ?? [],
  };
}
