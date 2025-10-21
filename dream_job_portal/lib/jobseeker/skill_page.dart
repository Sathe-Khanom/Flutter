import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/skill.dart';
import '../service/skill_service.dart';



class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  _SkillListScreenState createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  // Future that will hold the list of skills fetched from the backend
  late Future<List<Skill>> futureSkills;
  final SkillService _skillService = SkillService();

  // List of standard skill levels for the dropdown/editing dialog
  final List<String> _levelOptions = [
    'Beginner',
    'Intermediate',
    'Expert',
    'Master',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    _refreshSkills();
  }

  // Helper method to refresh the list of skills
  void _refreshSkills() {
    setState(() {
      futureSkills = _skillService.getAllSkills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Skills'),
        backgroundColor: Colors.deepOrange, // Using Deep Orange for the theme
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
            onPressed: _refreshSkills,
          ),
        ],
      ),
      body: FutureBuilder<List<Skill>>(
        future: futureSkills,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center,));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No skills recorded. Tap + to add one!'));
          } else {
            final skills = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Skill details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Skill Name (Bold)
                              Text(
                                skill.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Level
                              Text(
                                'Level: ${skill.level}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
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
                              onPressed: () => _showEditDialog(skill, index, skills),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(skill),
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
      // Floating Action Button for adding a new skill
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation/dialog for adding a new skill
          _showSnackBar(context, 'TODO: Implement Add Skill Screen', Colors.deepOrange);
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Modal Dialogs and Helpers ---

  // Confirmation dialog for deletion
  void _confirmDelete(Skill skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the skill: "${skill.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                // The Skill model ensures 'id' is present as it's not nullable
                await _skillService.deleteSkill(skill.id);
                _refreshSkills(); // Refresh the list
                _showSnackBar(context, 'Skill deleted successfully', Colors.green);
              } catch (e) {
                _showSnackBar(context, 'Failed to delete skill', Colors.red);
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

  // Modal dialog to edit skill in-place
  void _showEditDialog(Skill skill, int index, List<Skill> skills) {
    TextEditingController nameController = TextEditingController(text: skill.name);
    // Ensure the current level is in the options or default to the first option
    String? selectedLevel = _levelOptions.contains(skill.level)
        ? skill.level
        : _levelOptions.first;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Skill'),
        content: StatefulBuilder( // Use StatefulBuilder to manage level dropdown state
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Skill Name', nameController, required: true),
                    const SizedBox(height: 12),
                    // Level Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: const InputDecoration(
                        labelText: 'Proficiency Level',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _levelOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedLevel = newValue;
                          });
                        }
                      },
                      validator: (value) => value == null ? 'Skill level is required.' : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedLevel != null) {
                final Skill updatedSkill = Skill(
                  id: skill.id, // Keep ID for update
                  name: nameController.text.trim(),
                  level: selectedLevel!,
                );

                try {
                  // Call API to update backend
                  Skill savedSkill = await _skillService.updateSkill(updatedSkill);

                  // Update UI with response from backend
                  setState(() {
                    skills[index] = savedSkill;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Skill updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update skill', Colors.red);
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
