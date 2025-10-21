import 'package:code/entity/education.dart';
import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/eucation_service.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/training.dart';
import '../service/training_service.dart';

// StatefulWidget to display a list of Education records
class TrainingListScreen extends StatefulWidget {
  @override
  _TrainingListScreenState createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  // Future that will hold the list of educations fetched from backend
  late Future<List<Training>> futureTraining;

  @override
  void initState() {
    super.initState();
    // Fetch education data when the screen initializes
    futureTraining = TrainingService().fetchTraining();
    
    print(futureTraining);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Training'), // Screen title
        backgroundColor: Colors.indigo,
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
        // AppBar color
      ),
      body: FutureBuilder<List<Training>>(
        // Listen to the future to get data asynchronously
        future: futureTraining,
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
            return Center(child: Text('No Training records found'));
          }
          // If data is successfully fetched
          else {
            final training = snapshot.data!;

            // Display list of education records
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: training.length,
              itemBuilder: (context, index) {
                final tra = training[index];

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
                                '${tra.title} - ${tra.institute}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              SizedBox(height: 6), // Spacing
                              // Board and year
                              Text(
                                '${tra.duration}, ${tra.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4), // Small spacing
                              // Result

                            ],
                          ),
                        ),

                        // Right side: Edit button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange[800]),
                          onPressed: () {
                            // Open modal dialog to edit this education
                            _showEditDialog(tra, index, training);
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
  void _showEditDialog(Training tra, int index, List<Training> training) {
    // Controllers for each field to edit
    TextEditingController titleController = TextEditingController(text: tra.title);
    TextEditingController instituteController = TextEditingController(text: tra.institute);
    TextEditingController durationController = TextEditingController(text: tra.duration);
    TextEditingController descriptionController = TextEditingController(text: tra.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Training'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Title', titleController),
              _buildTextField('Institute', instituteController),
              _buildTextField('Duration', durationController),
              _buildTextField('Description', descriptionController),
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
              tra.title = titleController.text;
              tra.institute = instituteController.text;
              tra.duration = durationController.text;
              tra.description = descriptionController.text;

              try {
                // Call API to update backend
                Training savedTra = await TrainingService().updateTraining(tra);

                // Update UI with response from backend
                setState(() {
                  training[index] = savedTra;
                });

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Training updated successfully')),
                );
              } catch (e) {
                print('Update failed: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update Training')),
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
