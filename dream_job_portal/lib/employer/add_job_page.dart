import 'package:flutter/material.dart';
import 'dart:convert';

// NOTE: Please ensure these imports point to your actual file locations
import 'package:code/service/job_service.dart';
import 'package:code/entity/job.dart';
import 'package:code/service/location_service.dart';
import 'package:code/service/category_service.dart';
import 'package:code/entity/location.dart';
import 'package:code/entity/category.dart';

class AddJobForm extends StatefulWidget {
  const AddJobForm({super.key});

  @override
  State<AddJobForm> createState() => _AddJobFormState();
}

class _AddJobFormState extends State<AddJobForm> {
  final _formKey = GlobalKey<FormState>();

  // --- 1. Define ALL controllers for input fields ---
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _responsibilitiesController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _postedDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // --- Dropdown Data (To hold real entities from API) ---
  List<Location> _locations = [];
  List<Category> _categories = [];

  // --- Selected IDs and Job Type ---
  int? _selectedLocationId;
  int? _selectedCategoryId;
  String? _selectedJobType;

  String? successMessage;
  String? errorMessage;
  bool _isLoading = false; // For job submission state
  bool _isDataLoading = true; // For initial data loading state

  final JobService _jobService = JobService();
  final LocationService _locationService = LocationService();
  final CategoryService _categoryService = CategoryService();

// --- INITIAL STATE: Fetch Location and Category Data ---
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final locations = await _locationService.getAllLocations();
      final categories = await _categoryService.getAllCategories();

      if (!mounted) return;

      setState(() {
        _locations = locations;
        _categories = categories;
        _isDataLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = '❌ Error loading static data: ${e.toString()}';
        _isDataLoading = false;
      });
    }
  }
// --------------------------------------------------------

  // Utility: Pick a date and update controller
  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      // Format date to YYYY-MM-DD
      controller.text = date.toIso8601String().split('T').first;
    }
  }

  // --- CORRECTED & UNIFIED _onSubmit method for Job Posting ---
  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() {
        errorMessage = '❌ Please fill all required fields correctly.';
        successMessage = null;
      });
      return;
    }

    // Ensure Location and Category IDs are selected
    if (_selectedLocationId == null || _selectedCategoryId == null) {
      if (!mounted) return;
      setState(() {
        errorMessage = '❌ Please select a Location and Job Field.';
        _isLoading = false;
      });
      return;
    }

    // Form is valid, proceed with submission
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    // 3. Prepare data map with NESTED objects for the API (Required by your backend)
    final jobData = {
      'title': _titleController.text,
      'description': _purposeController.text,
      'keyresponsibility': _responsibilitiesController.text,
      'edurequirement': _educationController.text,
      'exprequirement': _experienceController.text,
      'benefits': _benefitsController.text,
      'salary': double.tryParse(_salaryController.text) ?? 0,
      'jobType': _selectedJobType,
      'postedDate': _postedDateController.text,
      'endDate': _endDateController.text,
      'location': {'id': _selectedLocationId},
      'category': {'id': _selectedCategoryId},
    };

    print("📤 Sending Job Data: ${jsonEncode(jobData)}");



    try {
      // 4. Call the async createJob method
      final createdJob = await _jobService.createJob(jobData);

      // --- SUCCESS LOGIC ---
      if (!mounted) return;
      setState(() {
        successMessage = '✅ Job added successfully!';
        errorMessage = null;
        _isLoading = false;

        // Resetting form fields and selected values
        _formKey.currentState?.reset();
        _selectedLocationId = null;
        _selectedCategoryId = null;
        _selectedJobType = null;
        _salaryController.clear();
        _postedDateController.clear();
        _endDateController.clear();
      });

    } catch (e) {
      // --- ERROR LOGIC ---
      if (!mounted) return;
      setState(() {
        // Print the full error for debugging in the console
        print('Job Creation Failed: $e');
        errorMessage = '❌ Failed to create job. Check console for details: ${e.toString()}';
        successMessage = null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _purposeController.dispose();
    _responsibilitiesController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _benefitsController.dispose();
    _salaryController.dispose();
    _postedDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // ******************************************************************
  // ************************* BUILD METHOD ***************************
  // ******************************************************************

  @override
  Widget build(BuildContext context) {
    // If data is loading, show a spinner
    if (_isDataLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('🎨 Add New Job'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If data loading failed, show the error
    if (errorMessage != null && _locations.isEmpty && _categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('🎨 Add New Job'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load job creation data. Please check your API connection.',
              style: TextStyle(color: Colors.red.shade700, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Normal Form Build
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Add New Job'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      '🚀 Add New Job',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F61),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Text Fields
                    _buildTextField('Job Title', 'Enter job title', _titleController),
                    _buildTextField('Job Purpose', 'Enter job purpose', _purposeController),
                    _buildTextField('Key Responsibilities', 'List key responsibilities', _responsibilitiesController),
                    _buildTextField('Education Requirements', 'List education requirements', _educationController),
                    _buildTextField('Experience Requirements', 'List experience requirements', _experienceController),
                    _buildTextField('Benefits', 'Mention any benefits', _benefitsController),

                    // --- LOCATION DROPDOWN ---
                    _buildLocationDropdown(),

                    // --- CATEGORY DROPDOWN ---
                    _buildCategoryDropdown(),

                    _buildNumberField('Salary', _salaryController),

                    _buildDropdown('Job Type', ['Full-Time', 'Part-Time', 'Internship'], _selectedJobType, (val) {
                      setState(() => _selectedJobType = val);
                    }),

                    _buildDateField('Post Date', _postedDateController),
                    _buildDateField('Deadline', _endDateController),

                    const SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                          : const Text('Submit'),
                    ),

                    const SizedBox(height: 16),
                    if (successMessage != null)
                      Text(successMessage!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    if (errorMessage != null)
                      Text(errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ******************************************************************
  // *********************** BUILDER METHODS **************************
  // ******************************************************************

  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<int>(
        value: _selectedLocationId,
        items: _locations.map((loc) {
          return DropdownMenuItem<int>(
            value: loc.id,
            child: Text(loc.name),
          );
        }).toList(),
        onChanged: (int? newId) {
          setState(() => _selectedLocationId = newId);
        },
        decoration: const InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Location is required.' : null,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<int>(
        value: _selectedCategoryId,
        items: _categories.map((cat) {
          return DropdownMenuItem<int>(
            value: cat.id,
            child: Text(cat.name),
          );
        }).toList(),
        onChanged: (int? newId) {
          setState(() => _selectedCategoryId = newId);
        },
        decoration: const InputDecoration(
          labelText: 'Job Field',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Job Field is required.' : null,
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? '$label is required.' : null,
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label is required.';
          final number = int.tryParse(value);
          if (number == null || number <= 0) return '$label must be a positive number.';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selected, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selected,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null ? '$label is required.' : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(controller),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? '$label is required.' : null,
      ),
    );
  }
}