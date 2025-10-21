import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/hobby.dart';
import '../service/hobby_service.dart';



class HobbyListScreen extends StatefulWidget {
  const HobbyListScreen({super.key});

  @override
  _HobbyListScreenState createState() => _HobbyListScreenState();
}

class _HobbyListScreenState extends State<HobbyListScreen> {
  // Future that will hold the list of hobbies fetched from the backend
  late Future<List<Hobby>> futureHobbies;
  final HobbyService _hobbyService = HobbyService();

  @override
  void initState() {
    super.initState();
    // Fetch hobby data when the screen initializes
    _refreshHobbies();
  }

  // Helper method to refresh the list of hobbies
  void _refreshHobbies() {
    // Note: The service methods require a token in the original definition,
    // but based on your Service implementation, it handles calling AuthService() internally.
    setState(() {
      // Passing null for token as the service handles fetching it internally
      futureHobbies = _hobbyService.getAllHobbies(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hobbies'),
        backgroundColor: Colors.pink, // Using pink for a distinct theme

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
            onPressed: _refreshHobbies,
          ),
        ],
      ),
      body: FutureBuilder<List<Hobby>>(
        future: futureHobbies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hobbies found. Tap + to add one!'));
          } else {
            final hobbies = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: hobbies.length,
              itemBuilder: (context, index) {
                final hobby = hobbies[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hobby Name
                        Expanded(
                          child: Text(
                            hobby.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.pink,
                            ),
                          ),
                        ),

                        // Action buttons (Edit and Delete)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.amber[700], size: 20),
                              onPressed: () => _showEditDialog(hobby, index, hobbies),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(hobby),
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
      // Floating Action Button for adding a new hobby
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation to an Add Hobby screen or show a quick add dialog
          _showSnackBar(context, 'TODO: Implement Add Hobby', Colors.blueGrey);
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Modal Dialogs and Helpers ---

  // Confirmation dialog for deletion
  void _confirmDelete(Hobby hobby) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the hobby: "${hobby.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                if (hobby.id != null) {
                  await _hobbyService.deleteHobby(hobby.id!);
                  _refreshHobbies(); // Refresh the list
                  _showSnackBar(context, 'Hobby deleted successfully', Colors.green);
                }
              } catch (e) {
                _showSnackBar(context, 'Failed to delete hobby', Colors.red);
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

  // Modal dialog to edit hobby in-place
  void _showEditDialog(Hobby hobby, int index, List<Hobby> hobbies) {
    TextEditingController nameController = TextEditingController(text: hobby.name);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Hobby'),
        content: Form(
          key: formKey,
          child: _buildTextField('Hobby Name', nameController, required: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final Hobby updatedHobby = Hobby(
                  id: hobby.id, // Keep ID for update
                  name: nameController.text.trim(),
                );

                try {
                  // Call API to update backend
                  Hobby savedHobby = await _hobbyService.updateHobby(updatedHobby);

                  // Update UI with response from backend
                  setState(() {
                    hobbies[index] = savedHobby;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Hobby updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update hobby', Colors.red);
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
