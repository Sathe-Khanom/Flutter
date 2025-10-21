import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/extracurricular.dart';
import '../service/extracurricular_service.dart';



class ExtracurricularListScreen extends StatefulWidget {
  const ExtracurricularListScreen({super.key});

  @override
  _ExtracurricularListScreenState createState() => _ExtracurricularListScreenState();
}

class _ExtracurricularListScreenState extends State<ExtracurricularListScreen> {
  // Future that will hold the list of extracurriculars fetched from the backend
  late Future<List<Extracurricular>> futureExtracurriculars;
  final ExtracurricularService _extracurricularService = ExtracurricularService();

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    futureExtracurriculars = _extracurricularService.getAllExtracurriculars();
  }

  // Helper method to refresh the list of extracurriculars
  void _refreshExtracurriculars() {
    setState(() {
      futureExtracurriculars = _extracurricularService.getAllExtracurriculars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracurricular Activities'),
        backgroundColor: Colors.purple, // Using a distinct color theme
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
            onPressed: _refreshExtracurriculars,
          ),
        ],
      ),
      body: FutureBuilder<List<Extracurricular>>(
        future: futureExtracurriculars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center,));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No extracurricular records found.'));
          } else {
            final extracurriculars = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: extracurriculars.length,
              itemBuilder: (context, index) {
                final extra = extracurriculars[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.purple, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side: Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title (bold text)
                              Text(
                                extra.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Role
                              Text(
                                'Role: ${extra.role}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Description
                              Text(
                                extra.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Right side: Action buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.amber[700], size: 20),
                              onPressed: () => _showEditDialog(extra, index, extracurriculars),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(extra),
                            ),
                          ],
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
      // Floating Action Button for adding a new record
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation to an Add Extracurricular screen
          _showSnackBar(context, 'TODO: Navigate to Add Extracurricular Screen', Colors.blueGrey);
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Modal Dialogs and Helpers ---

  // Confirmation dialog for deletion
  void _confirmDelete(Extracurricular extra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the activity: "${extra.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                if (extra.id != null) {
                  await _extracurricularService.deleteExtracurricular(extra.id!);
                  _refreshExtracurriculars(); // Refresh the list
                  _showSnackBar(context, 'Activity deleted successfully', Colors.green);
                }
              } catch (e) {
                _showSnackBar(context, 'Failed to delete activity', Colors.red);
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

  // Modal dialog to edit extracurricular in-place
  void _showEditDialog(Extracurricular extra, int index, List<Extracurricular> extracurriculars) {
    TextEditingController titleController = TextEditingController(text: extra.title);
    TextEditingController roleController = TextEditingController(text: extra.role);
    TextEditingController descriptionController = TextEditingController(text: extra.description);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Extracurricular'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Title', titleController, required: true),
                _buildTextField('Role/Position', roleController, required: true),
                _buildTextField('Description', descriptionController, maxLines: 5),
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
                final Extracurricular updatedExtra = Extracurricular(
                  id: extra.id, // Keep ID for update
                  title: titleController.text.trim(),
                  role: roleController.text.trim(),
                  description: descriptionController.text.trim(),
                );

                try {
                  // Call API to update backend
                  Extracurricular savedExtra = await _extracurricularService.updateExtracurricular(updatedExtra);

                  // Update UI with response from backend
                  setState(() {
                    extracurriculars[index] = savedExtra;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Activity updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update activity', Colors.red);
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
