import 'package:flutter/material.dart';

class AddJobForm extends StatefulWidget {
  const AddJobForm({super.key});

  @override
  State<AddJobForm> createState() => _AddJobFormState();
}

class _AddJobFormState extends State<AddJobForm> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  final TextEditingController _postedDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Dummy dropdown options
  final List<String> _locations = ['Dhaka', 'Chittagong', 'Sylhet'];
  final List<String> _categories = ['Software', 'Marketing', 'Finance'];

  String? _selectedLocation;
  String? _selectedCategory;
  String? _selectedJobType;

  String? successMessage;
  String? errorMessage;

  // Utility: Pick a date and update controller
  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      controller.text = date.toIso8601String().split('T').first;
    }
  }

  void _onSubmit() {
    setState(() {
      isSubmitted = true;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        successMessage = '✅ Job added successfully!';
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage = '❌ Please fill all required fields correctly.';
        successMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

                    _buildTextField('Job Title', 'Enter job title'),
                    _buildTextField('Job Purpose', 'Enter job purpose'),
                    _buildTextField('Key Responsibilities', 'List key responsibilities'),
                    _buildTextField('Education Requirements', 'List education requirements'),
                    _buildTextField('Experience Requirements', 'List experience requirements'),
                    _buildTextField('Benefits', 'Mention any benefits'),

                    _buildDropdown('Location', _locations, _selectedLocation, (val) {
                      setState(() => _selectedLocation = val);
                    }),
                    _buildDropdown('Job Field', _categories, _selectedCategory, (val) {
                      setState(() => _selectedCategory = val);
                    }),
                    _buildNumberField('Salary'),

                    _buildDropdown('Job Type', ['Full-Time', 'Part-Time', 'Internship'], _selectedJobType, (val) {
                      setState(() => _selectedJobType = val);
                    }),

                    _buildDateField('Post Date', _postedDateController),
                    _buildDateField('Deadline', _endDateController),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Submit'),
                    ),

                    const SizedBox(height: 16),
                    if (successMessage != null)
                      Text(successMessage!, style: const TextStyle(color: Colors.green)),
                    if (errorMessage != null)
                      Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? '$label is required.' : null,
      ),
    );
  }

  Widget _buildNumberField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
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
