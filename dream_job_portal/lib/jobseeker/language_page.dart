import 'package:code/jobseeker/job_seeker_profile.dart';
import 'package:code/service/job_seeker_service.dart';
import 'package:flutter/material.dart';

import '../entity/language.dart';
import '../service/language_service.dart';



class LanguageListScreen extends StatefulWidget {
  const LanguageListScreen({super.key});

  @override
  _LanguageListScreenState createState() => _LanguageListScreenState();
}

class _LanguageListScreenState extends State<LanguageListScreen> {
  // Future that will hold the list of languages fetched from the backend
  late Future<List<Language>> futureLanguages;
  final LanguageService _languageService = LanguageService();

  // List of standard proficiency options for the dropdown/editing dialog
  final List<String> _proficiencyOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Native/Fluent',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    _refreshLanguages();
  }

  // Helper method to refresh the list of languages
  void _refreshLanguages() {
    setState(() {
      futureLanguages = _languageService.getAllLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Skills'),
        backgroundColor: Colors.blueGrey, // Using a distinct color theme
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
            onPressed: _refreshLanguages,
          ),
        ],
      ),
      body: FutureBuilder<List<Language>>(
        future: futureLanguages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}', textAlign: TextAlign.center,));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No language records found. Tap + to add one!'));
          } else {
            final languages = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Language details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Language Name (Bold)
                              Text(
                                lang.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Proficiency Level
                              Text(
                                'Proficiency: ${lang.proficiency}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
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
                              onPressed: () => _showEditDialog(lang, index, languages),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(lang),
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
      // Floating Action Button for adding a new language
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation/dialog for adding a new language
          _showSnackBar(context, 'TODO: Implement Add Language Screen', Colors.blueGrey);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Modal Dialogs and Helpers ---

  // Confirmation dialog for deletion
  void _confirmDelete(Language lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${lang.name}" from your language list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                // The Language model ensures 'id' is present as it's not nullable
                await _languageService.deleteLanguage(lang.id);
                _refreshLanguages(); // Refresh the list
                _showSnackBar(context, 'Language deleted successfully', Colors.green);
              } catch (e) {
                _showSnackBar(context, 'Failed to delete language', Colors.red);
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

  // Modal dialog to edit language in-place
  void _showEditDialog(Language lang, int index, List<Language> languages) {
    TextEditingController nameController = TextEditingController(text: lang.name);
    String? selectedProficiency = lang.proficiency.isNotEmpty ? lang.proficiency : _proficiencyOptions.first;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Language'),
        content: StatefulBuilder( // Use StatefulBuilder to manage proficiency dropdown state
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Language Name', nameController, required: true),
                    const SizedBox(height: 12),
                    // Proficiency Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedProficiency,
                      decoration: const InputDecoration(
                        labelText: 'Proficiency Level',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _proficiencyOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedProficiency = newValue;
                          });
                        }
                      },
                      validator: (value) => value == null ? 'Proficiency is required.' : null,
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
              if (formKey.currentState!.validate() && selectedProficiency != null) {
                final Language updatedLang = Language(
                  id: lang.id, // Keep ID for update
                  name: nameController.text.trim(),
                  proficiency: selectedProficiency!,
                );

                try {
                  // Call API to update backend
                  Language savedLang = await _languageService.updateLanguage(updatedLang);

                  // Update UI with response from backend
                  setState(() {
                    languages[index] = savedLang;
                  });

                  Navigator.pop(context); // Close dialog
                  _showSnackBar(context, 'Language updated successfully', Colors.green);
                } catch (e) {
                  print('Update failed: $e');
                  _showSnackBar(context, 'Failed to update language', Colors.red);
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
