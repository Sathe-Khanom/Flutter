import 'package:flutter/material.dart';

import '../entity/location.dart';
import '../service/location_service.dart';
// Your service class

class LocationManagement extends StatefulWidget {
  const LocationManagement({super.key});

  @override
  State<LocationManagement> createState() => _LocationManagementState();
}

class _LocationManagementState extends State<LocationManagement> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final LocationService _locationService = LocationService(); // replace with your base URL

  List<Location> _locations = [];
  bool _editMode = false;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final locations = await _locationService.getAllLocations();
      setState(() {
        _locations = locations;
      });
    } catch (e) {
      debugPrint('Failed to fetch locations: $e');
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    setState(() {
      _editMode = false;
      _editingId = null;
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final location = Location(name: _nameController.text);

    try {
      if (_editMode && _editingId != null) {
        await _locationService.updateLocation(_editingId!, location);
      } else {
        await _locationService.createLocation(location);
      }

      _resetForm();
      _fetchLocations();
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  void _editLocation(Location loc) {
    setState(() {
      _editMode = true;
      _editingId = loc.id;
      _nameController.text = loc.name;
    });
  }

  Future<void> _deleteLocation(int id) async {
    try {
      await _locationService.deleteLocation(id);
      _fetchLocations();
    } catch (e) {
      debugPrint('Failed to delete location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📍 Location Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Location Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Location name is required.' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _formKey.currentState != null &&
                            !_formKey.currentState!.validate()
                            ? null
                            : _onSubmit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        child: Text(_editMode ? 'Update Location' : 'Add Location'),
                      ),
                      const SizedBox(width: 12),
                      if (_editMode)
                        OutlinedButton(
                          onPressed: _resetForm,
                          child: const Text('Cancel'),
                        ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Table-like List
            Expanded(
              child: _locations.isEmpty
                  ? const Center(child: Text('No locations found.'))
                  : SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Location Name')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _locations.map((loc) {
                    return DataRow(
                      cells: [
                        DataCell(Text(loc.id?.toString() ?? '-')),
                        DataCell(Text(loc.name)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _editLocation(loc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLocation(loc.id!),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
