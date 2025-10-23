import 'package:code/jobseeker/cv_generator.dart';
import 'package:code/jobseeker/education_page.dart';
import 'package:code/jobseeker/my_Applications_Page.dart';
import 'package:code/jobseeker/refference_page.dart';
import 'package:code/jobseeker/skill_page.dart';
import 'package:code/jobseeker/summary_page.dart';
import 'package:code/jobseeker/training_page.dart';
import 'package:code/page/loginpage.dart';
import 'package:code/service/authservice.dart';
import 'package:code/service/summary_service.dart';
import 'package:flutter/material.dart';

import '../page/homepage.dart';
import '../page/job_list_page.dart';
import 'experience_page.dart';
import 'extracurricular_page.dart';
import 'hobby_page.dart';
import 'language_page.dart';

class JobSeekerProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();
  final SummaryService summaryService = SummaryService();

  JobSeekerProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8085/images/jobSeeker/";
    final String? photoName = profile['photo'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl$photoName"
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Seeker Profile"),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context, photoUrl),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(photoUrl),
            const SizedBox(height: 24),

            // *** CV GENERATION BUTTON ***
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Eikhane generateAndPrintCV function-ta call korun
                  generateAndPrintCV(profile);
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Generate CV (PDF)",
                    style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Personal Info"),
            _buildInfoRow("Phone", profile['phone']),
            _buildInfoRow("Gender", profile['gender']),
            _buildInfoRow("Address", profile['address']),
            _buildInfoRow("Date of Birth", profile['dateOfBirth']),
            _buildInfoRow("Blood Group", profile['summery']?[0]?['bloodGroup']),
            _buildInfoRow("Height", profile['summery']?[0]?['height']),
            _buildInfoRow("Weight", profile['summery']?[0]?['weight']),
            _buildInfoRow("Nationality", profile['summery']?[0]?['nationality']),
            const SizedBox(height: 20),

            _buildSectionTitle("Education"),
            ..._buildEducationSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("Skills"),
            _buildSkillsSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("Experience"),
            ..._buildExperienceSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("Hobbies"),
            _buildHobbiesSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("Languages"),
            _buildLanguagesSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("References"),
            ..._buildReferencesSection(),

            const SizedBox(height: 20),
            _buildSectionTitle("Trainings"),
            ..._buildTrainingsSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ------------------------
  // PROFILE HEADER
  // ------------------------
  Widget _buildProfileHeader(String? photoUrl) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              border: Border.all(color: Colors.purple, width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: (photoUrl != null)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
          ),
          const SizedBox(height: 12),
          Text(profile['name'] ?? 'Unknown', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Email: ${profile['user']?['email'] ?? 'N/A'}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }

  // ------------------------
  // DRAWER
  // ------------------------
  Drawer _buildDrawer(BuildContext context, String? photoUrl) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.purple),
            accountName: Text(profile['name'] ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(profile['user']?['email'] ?? 'N/A'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: (photoUrl != null)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
          ),
          _buildDrawerItem(context, Icons.person, "My Profile", () => Navigator.pop(context)),

          _buildDrawerItem(context, Icons.home, "Home", (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeTab()));
          }),

          _buildDrawerItem(context, Icons.work, "Applied Jobs", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyApplicationsPage()));
          }),
          _buildDrawerItem(context, Icons.list_alt, "All Jobs", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobListPage()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Summary", () async {
            final summary = await summaryService.getJobSeekerSummary();
            if (summary != null) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobSeekerSummary(summary: summary)));
            }
          }),
          _buildDrawerItem(context, Icons.add_box, "Education", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EducationListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Training", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TrainingListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Experience", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ExperienceListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Extracurricular", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ExtracurricularListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Hobby", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HobbyListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Language", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LanguageListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Skill", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SkillListScreen()));
          }),
          _buildDrawerItem(context, Icons.add_box, "Reference", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReferenceListScreen()));
          }),

          const Divider(),
          _buildDrawerItem(context, Icons.logout, "Logout", () async {
            await _authService.logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
          }, color: Colors.red),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  // ------------------------
  // SECTION TITLES
  // ------------------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value?.toString() ?? "N/A")),
        ],
      ),
    );
  }

  // ------------------------
  // EDUCATION
  // ------------------------
  List<Widget> _buildEducationSection() {
    return List.generate(profile['educations']?.length ?? 0, (i) {
      final edu = profile['educations'][i];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${edu['level']} - ${edu['institute']}", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${edu['board'] ?? 'N/A'}, ${edu['year']}"),
              Text("Result: ${edu['result']}"),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSkillsSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(profile['skills']?.length ?? 0, (i) {
        final skill = profile['skills'][i];
        return Chip(label: Text("${skill['name']} (${skill['level']})"), backgroundColor: Colors.indigo[50]);
      }),
    );
  }

  List<Widget> _buildExperienceSection() {
    return List.generate(profile['experiences']?.length ?? 0, (i) {
      final exp = profile['experiences'][i];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text("${exp['position']} - ${exp['company']}"),
          subtitle: Text("${exp['fromDate'] ?? 'N/A'} to ${exp['toDate'] ?? 'N/A'}\n${exp['description'] ?? ''}"),
        ),
      );
    });
  }

  Widget _buildHobbiesSection() {
    return Wrap(
      spacing: 8,
      children: List.generate(profile['hobbies']?.length ?? 0, (i) {
        final h = profile['hobbies'][i];
        return Chip(label: Text(h['name']));
      }),
    );
  }

  Widget _buildLanguagesSection() {
    return Wrap(
      spacing: 8,
      children: List.generate(profile['languages']?.length ?? 0, (i) {
        final lang = profile['languages'][i];
        return Chip(label: Text("${lang['name']} (${lang['proficiency']})"));
      }),
    );
  }

  List<Widget> _buildReferencesSection() {
    return List.generate(profile['refferences']?.length ?? 0, (i) {
      final ref = profile['refferences'][i];
      return ListTile(
        title: Text(ref['name']),
        subtitle: Text("${ref['relation']} - ${ref['contact']}"),
        leading: Icon(Icons.person, color: Colors.purple),
      );
    });
  }

  List<Widget> _buildTrainingsSection() {
    return List.generate(profile['trainings']?.length ?? 0, (i) {
      final tr = profile['trainings'][i];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(tr['title']),
          subtitle: Text("${tr['institute']} - ${tr['duration']}"),
        ),
      );
    });
  }
}
