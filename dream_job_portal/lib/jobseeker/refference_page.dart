import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/reference.dart';
import '../service/refference_service.dart';



class ReferenceListScreen extends StatefulWidget {
  const ReferenceListScreen({super.key});

  @override
  _ReferenceListScreenState createState() => _ReferenceListScreenState();
}

class _ReferenceListScreenState extends State<ReferenceListScreen> {
  // Future that will hold the list of references fetched from the backend
  late Future<List<Reference>> futureReferences;
  final RefferenceService _referenceService = RefferenceService(); // Instantiate the service

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    _refreshReferences();
  }

  // Helper method to refresh the list of references
  void _refreshReferences() {
    setState(() {
      futureReferences = _referenceService.getAllReferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional References'),
        backgroundColor: Colors.teal, // Using a distinct color theme
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
            onPressed: _refreshReferences,
          ),
        ],
      ),
      body: FutureBuilder<List<Reference>>(
        future: futureReferences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No references found. Tap + to add one.'));
          } else {
            final references = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: references.length,
              itemBuilder: (context, index) {
                final ref = references[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Reference details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name (Bold)
                              Text(
                                ref.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Relation
                              Text(
                                'Relation: ${ref.relation}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Contact Info
                              Text(
                                'Contact: ${ref.contact}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side: Action buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.amber[700], size: 20),
                              onPressed: () => _showEditDialog(ref, index, references),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(ref),
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
      // Floating Action Button for adding a new reference
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation/dialog for adding a new reference
          _showSnackBar(context, 'TODO: Implement Add Reference Screen', Colors.teal);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Modal Dialogs and Helpers ---

  // Confirmation dialog for deletion
  void _confirmDelete(Reference ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the reference for "${ref.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                // The Reference model ensures 'id' is present as it's not nullable
                await _referenceService.deleteReference(ref.id);
                _refreshReferences(); // Refresh the list
                _showSnackBar(context, 'Reference deleted successfully', Colors.green);
              } catch (e) {
                _showSnackBar(context, 'Failed to delete reference', Colors.red);
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

  // Modal dialog to edit reference in-place
  void _showEditDialog(Reference ref, int index, List<Reference> references) {
    TextEditingController nameController = TextEditingController(text: ref.name);
    TextEditingController contactController = TextEditingController(text: ref.contact);
    TextEditingController relationController = TextEditingController(text: ref.relation);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Reference'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Full Name', nameController, required: true),
                _buildTextField('Contact (Email/Phone)', contactController, required: true),
                _buildTextField('Relation (e.g., Former Manager)', relationController, required: true),
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
                final Reference updatedRef = Reference(
                  id: ref.id, // Keep ID for update
                  name: nameController.text.trim(),
                  contact: contactController.text.trim(),
                  relation: relationController.text.trim(),
                );

                try {
                  // Call API to update backend
                  Reference savedRef = await _referenceService.updateReference(updatedRef);

                  // Update UI with response from backend
                  setState(() {
                    references[index] = savedRef;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Reference updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update reference', Colors.red);
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
  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
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
