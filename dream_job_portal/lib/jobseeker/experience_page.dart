import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/experience.dart';
import '../service/experience_service.dart';



class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  _ExperienceListScreenState createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  // Future that will hold the list of experiences fetched from the backend
  late Future<List<Experience>> futureExperiences;

  final ExperienceService _experienceService = ExperienceService();

  @override
  void initState() {
    super.initState();
    // Fetch experience data when the screen initializes
    futureExperiences = _experienceService.getAllExperiences();
  }

  // Helper method to refresh the list of experiences
  void _refreshExperiences() {
    setState(() {
      futureExperiences = _experienceService.getAllExperiences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Experience'),
        backgroundColor: Colors.teal, // Using a different color theme

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

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshExperiences,
          ),
        ],
      ),
      body: FutureBuilder<List<Experience>>(
        future: futureExperiences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center,));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No professional experience records found.'));
          } else {
            final experiences = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final exp = experiences[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Position and Company (Bold Title)
                            Expanded(
                              child: Text(
                                '${exp.position} at ${exp.company}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            // Action buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.amber[800], size: 20),
                                  onPressed: () => _showEditDialog(exp, index, experiences),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () => _confirmDelete(exp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Dates
                        Text(
                          '${exp.fromDate ?? 'Start Date Unknown'} - ${exp.toDate ?? 'Present'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (exp.description != null && exp.description!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          // Description
                          Text(
                            exp.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // Floating Action Button for adding a new experience
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation to an Add Experience screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('TODO: Navigate to Add Experience Screen')),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Confirmation dialog for deletion
  void _confirmDelete(Experience exp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the experience at ${exp.company}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                // Call API to delete backend record
                if (exp.id != null) {
                  await _experienceService.deleteExperience(exp.id!);
                  _refreshExperiences(); // Refresh the list
                  _showSnackBar(context, 'Experience deleted successfully', Colors.green);
                }
              } catch (e) {
                _showSnackBar(context, 'Failed to delete experience', Colors.red);
                print('Deletion failed: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Modal dialog to edit experience in-place
  void _showEditDialog(Experience exp, int index, List<Experience> experiences) {
    // Controllers for each field to edit
    TextEditingController companyController = TextEditingController(text: exp.company);
    TextEditingController positionController = TextEditingController(text: exp.position);
    TextEditingController fromDateController = TextEditingController(text: exp.fromDate);
    TextEditingController toDateController = TextEditingController(text: exp.toDate);
    TextEditingController descriptionController = TextEditingController(text: exp.description);

    // Key for form validation
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Experience'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Company', companyController, required: true),
                _buildTextField('Position', positionController, required: true),
                _buildTextField('Start Date', fromDateController),
                _buildTextField('End Date (Leave blank for Present)', toDateController),
                _buildTextField('Description', descriptionController, maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Create a new (immutable) Experience object with updated data
                final Experience updatedExp = Experience(
                  id: exp.id, // Must keep the existing ID for update
                  company: companyController.text.trim(),
                  position: positionController.text.trim(),
                  fromDate: fromDateController.text.trim().isNotEmpty ? fromDateController.text.trim() : null,
                  toDate: toDateController.text.trim().isNotEmpty ? toDateController.text.trim() : null,
                  description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
                );

                try {
                  // Call API to update backend
                  Experience savedExp = await _experienceService.updateExperience(updatedExp);

                  // Update UI with response from backend
                  setState(() {
                    experiences[index] = savedExp;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Experience updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update experience', Colors.red);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Helper method to build a styled text field
  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: required
            ? (value) {
          if (value == null || value.isEmpty) {
            return '$label is required.';
          }
          return null;
        }
            : null,
      ),
    );
  }

  // Helper for consistent SnackBar display
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
