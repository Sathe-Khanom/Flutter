import 'package:flutter/material.dart';

import '../entity/training.dart';
import '../service/training_service.dart';


class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final TrainingService _trainingService = TrainingService();
  late Future<List<Training>> _trainingFuture;
  List<Training> _trainings = []; // Local list to hold data

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
  }

  Future<void> _fetchTrainings() async {
    _trainingFuture = _trainingService.getTrainings().then((data) {
      _trainings = data; // Store data in local list
      return data;
    });
  }

  // Refresh data from API
  Future<void> _refresh() async {
    setState(() {
      _fetchTrainings(); // Refetching will update _trainingFuture and _trainings
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trainings'),
        backgroundColor: Colors.indigo, // Added aesthetic color
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Training>>(
          future: _trainingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No trainings available.'));
            }

            // Data is already stored in _trainings, but we use snapshot.data to ensure initial build
            // final trainings = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _trainings.length, // Use local list
              itemBuilder: (context, index) {
                final training = _trainings[index];
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
                        // Left side: Training details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Institute (bold text)
                              Text(
                                '${training.title} - ${training.institute}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              SizedBox(height: 6), // Spacing
                              // Duration
                              Text(
                                'Duration: ${training.duration}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4), // Small spacing
                              // Description
                              Text(
                                'Description: ${training.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis, // Added overflow handling
                              ),
                            ],
                          ),
                        ),

                        // Right side: Edit button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange[800]),
                          onPressed: () {
                            // Open modal dialog to edit this training
                            _showEditDialog(training, index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Modal dialog to edit training in-place
  void _showEditDialog(Training training, int index) {
    // Controllers for each field to edit
    TextEditingController titleController = TextEditingController(text: training.title);
    TextEditingController instituteController = TextEditingController(text: training.institute);
    TextEditingController durationController = TextEditingController(text: training.duration);
    TextEditingController descriptionController = TextEditingController(text: training.description);

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
              training.title = titleController.text;
              training.institute = instituteController.text;
              training.duration = durationController.text;
              training.description = descriptionController.text;

              try {
                // Call API to update backend
                Training savedTraining = await _trainingService.updateTraining(training);

                // Update UI with response from backend
                setState(() {
                  _trainings[index] = savedTraining;
                });

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Training updated successfully')),
                );
              } catch (e) {
                print('Update failed: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update training')),
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