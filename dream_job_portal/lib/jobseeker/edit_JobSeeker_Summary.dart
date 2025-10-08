import 'package:flutter/material.dart';
import 'package:code/service/summary_service.dart';

class EditJobSeekerSummary extends StatefulWidget {
  final Map<String, dynamic>? summary;

  const EditJobSeekerSummary({super.key, required this.summary});

  @override
  _EditJobSeekerSummaryState createState() => _EditJobSeekerSummaryState();
}

class _EditJobSeekerSummaryState extends State<EditJobSeekerSummary> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController fatherController;
  late TextEditingController motherController;
  late TextEditingController nationalityController;
  late TextEditingController religionController;
  late TextEditingController bloodGroupController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController nidController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final s = widget.summary ?? {};
    fatherController = TextEditingController(text: s['fatherName'] ?? '');
    motherController = TextEditingController(text: s['motherName'] ?? '');
    nationalityController = TextEditingController(text: s['nationality'] ?? '');
    religionController = TextEditingController(text: s['religion'] ?? '');
    bloodGroupController = TextEditingController(text: s['bloodGroup'] ?? '');
    heightController = TextEditingController(text: s['height'] ?? '');
    weightController = TextEditingController(text: s['weight'] ?? '');
    nidController = TextEditingController(text: s['nid'] ?? '');
    descriptionController = TextEditingController(text: s['description'] ?? '');
  }

  @override
  void dispose() {
    fatherController.dispose();
    motherController.dispose();
    nationalityController.dispose();
    religionController.dispose();
    bloodGroupController.dispose();
    heightController.dispose();
    weightController.dispose();
    nidController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveSummary() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedData = {
      'fatherName': fatherController.text,
      'motherName': motherController.text,
      'nationality': nationalityController.text,
      'religion': religionController.text,
      'bloodGroup': bloodGroupController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'nid': nidController.text,
      'description': descriptionController.text,
    };

    final success = await SummaryService()
        .updateSummary(widget.summary!['id'], updatedData);

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Summary updated successfully')));
      Navigator.pop(context, updatedData); // Return updated data
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to update summary')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.summary == null) {
      return const Scaffold(
        body: Center(child: Text('No summary data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Job Seeker Summary'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: fatherController,
                decoration: const InputDecoration(labelText: 'Father Name'),
              ),
              TextFormField(
                controller: motherController,
                decoration: const InputDecoration(labelText: 'Mother Name'),
              ),
              TextFormField(
                controller: nationalityController,
                decoration: const InputDecoration(labelText: 'Nationality'),
              ),
              TextFormField(
                controller: religionController,
                decoration: const InputDecoration(labelText: 'Religion'),
              ),
              TextFormField(
                controller: bloodGroupController,
                decoration: const InputDecoration(labelText: 'Blood Group'),
              ),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height'),
              ),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
              ),
              TextFormField(
                controller: nidController,
                decoration: const InputDecoration(labelText: 'NID'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveSummary,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
