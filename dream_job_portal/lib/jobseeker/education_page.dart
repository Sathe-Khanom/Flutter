import 'package:code/entity/education.dart';
import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/eucation_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

// StatefulWidget to display a list of Education records
class EducationListScreen extends StatefulWidget {
  @override
  _EducationListScreenState createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  // Future that will hold the list of educations fetched from backend
  late Future<List<Education>> futureEducations;
  final JobSeekerService jobSeekerService = JobSeekerService();

  @override
  void initState() {
    super.initState();
    // Fetch education data when the screen initializes
    futureEducations = EducationService().fetchEducations();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My Education'), // Screen title
        backgroundColor: Colors.indigo, // AppBar color
        automaticallyImplyLeading: true,

        leading: IconButton(

          icon: const Icon(Icons.arrow_back),

          onPressed: () async {
            final profile = await JobSeekerService().getJobSeekerProfile();

            if (profile != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => JobSeekerProfile(profile: profile),
                ),
              );
            }

          },
        ),

      ),
      body: FutureBuilder<List<Education>>(
        // Listen to the future to get data asynchronously
        future: futureEducations,
        builder: (context, snapshot) {
          // While waiting for data, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If an error occurs while fetching data
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If the data is empty
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No education records found'));
          }
          // If data is successfully fetched
          else {
            final educations = snapshot.data!;

            // Display list of education records
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: educations.length,
              itemBuilder: (context, index) {
                final edu = educations[index];

                // Card widget for each education record
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Education details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Level and institute (bold text)
                              Text(
                                '${edu.level} - ${edu.institute}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              SizedBox(height: 6), // Spacing
                              // Board and year
                              Text(
                                '${edu.board}, ${edu.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4), // Small spacing
                              // Result
                              Text(
                                'Result: ${edu.result}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side: Edit button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange[800]),
                          onPressed: () {
                            // Open modal dialog to edit this education
                            _showEditDialog(edu, index, educations);
                          },
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

  // Modal dialog to edit education in-place
  void _showEditDialog(Education edu, int index, List<Education> educations) {
    // Controllers for each field to edit
    TextEditingController levelController = TextEditingController(text: edu.level);
    TextEditingController instituteController = TextEditingController(text: edu.institute);
    TextEditingController boardController = TextEditingController(text: edu.board);
    TextEditingController resultController = TextEditingController(text: edu.result);
    TextEditingController yearController = TextEditingController(text: edu.year);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Education'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Level', levelController),
              _buildTextField('Institute', instituteController),
              _buildTextField('Board', boardController),
              _buildTextField('Result', resultController),
              _buildTextField('Year', yearController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Update local object
              edu.level = levelController.text;
              edu.institute = instituteController.text;
              edu.board = boardController.text;
              edu.result = resultController.text;
              edu.year = yearController.text;

              try {
                // Call API to update backend
                Education savedEdu = await EducationService().updateEducation(edu);

                // Update UI with response from backend
                setState(() {
                  educations[index] = savedEdu;
                });

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Education updated successfully')),
                );
              } catch (e) {
                print('Update failed: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update education')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }


  // Helper method to build a styled text field
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
