import 'package:flutter/material.dart';
import '../entity/employer.dart';
import '../entity/job.dart';
import '../service/apply_service.dart';
import '../service/employer_service.dart';
import '../service/job_service.dart';

class JobsByCompanyScreen extends StatefulWidget {
  @override
  _JobsByCompanyScreenState createState() => _JobsByCompanyScreenState();
}

class _JobsByCompanyScreenState extends State<JobsByCompanyScreen> {
  final EmployerService _employerService = EmployerService();
  final JobService _jobService = JobService();
  final ApplyService _applyService = ApplyService();

  late Future<List<Employer>> _employersFuture;
  List<Employer> _employers = [];
  Employer? _selectedEmployer;
  List<Job> _jobs = [];
  bool _isLoadingJobs = false;

  @override
  void initState() {
    super.initState();
    _employersFuture = _loadEmployers();
  }

  Future<List<Employer>> _loadEmployers() async {
    try {
      final employers = await _employerService.getAllEmployers();
      _employers = [
        Employer(
          id: -1,
          companyName: '-- Select Company --',
          contactPerson: '', email: '', password: '', phoneNumber: '',
          companyAddress: '', companyWebsite: '', industryType: '', logo: '',
        ),
        ...employers,
      ];
      return _employers;
    } catch (e) {
      print('Error loading employers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load companies: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return [];
    }
  }

  Future<void> _fetchJobsByCompany(Employer employer) async {
    setState(() {
      _isLoadingJobs = true;
      _jobs = [];
    });

    try {
      if (employer.id != null && employer.id != -1) {
        final jobs = await _jobService.getJobsByCompany(employer.companyName!);
        _jobs = jobs;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load jobs for ${employer.companyName}: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoadingJobs = false;
      });
    }
  }

  void _onCompanyChange(Employer? employer) {
    setState(() {
      _selectedEmployer = employer;
    });
    if (employer != null && employer.id != null && employer.id != -1) {
      _fetchJobsByCompany(employer);
    } else {
      setState(() {
        _jobs = [];
      });
    }
  }

  Future<void> _applyJob(int jobId, int employerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Application', style: TextStyle(color: Colors.grey)), // Subtle title
        content: const Text('Are you sure you want to apply for this job?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B7A8F)), // Muted apply button
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting application...', style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFF8DABAF)), // Soft submitting color
      );
      await _applyService.applyForJob(jobId: jobId, employerId: employerId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully applied! 🎉', style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFFA2DED0)), // Soft success green
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application failed: ${e.toString()} 😢', style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFFE57373)), // Soft error red
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs by Company', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        centerTitle: true,
      ),
      // Full screen background with a soft gradient
      extendBodyBehindAppBar: true, // App bar is part of the gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Soft, muted colors: light grey, subtle purple, subtle pink
            colors: [
              Color(0xFFE0E0E0), // Light Grey
              Color(0xFFEDE7F6), // Light Lavender
              Color(0xFFF8BBD0), // Light Pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This SizedBox is to push content down below the transparent app bar
              SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height),

              // Company Dropdown
              _buildCompanyDropdown(),

              const SizedBox(height: 25),

              // Jobs Cards
              _isLoadingJobs
                  ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)))
                  : _buildJobsList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildCompanyDropdown() {
    return FutureBuilder<List<Employer>>(
      future: _employersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading companies: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)));
        }

        final employers = _employers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Company to view jobs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF37474F)), // Darker text for readability
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Slightly transparent white
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), // Softer shadow
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<Employer>(
                  value: _selectedEmployer ?? employers[0],
                  hint: const Text('-- Select Company --', style: TextStyle(color: Colors.grey)),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7A8F)), // Muted dropdown icon
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                  items: employers.map((emp) {
                    return DropdownMenuItem<Employer>(
                      value: emp,
                      child: Text(
                        emp.companyName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: emp.id == -1 ? FontWeight.bold : FontWeight.normal,
                          color: emp.id == -1 ? const Color(0xFF6B7A8F) : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _onCompanyChange,
                  validator: (value) {
                    if (value == null || value.id == -1) {
                      return 'Please select a company';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJobsList() {
    if (_jobs.isEmpty && _selectedEmployer != null && _selectedEmployer!.id != -1) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 50, color: Color(0xFF6B7A8F)),
              const SizedBox(height: 10),
              Text(
                'No jobs found for "${_selectedEmployer?.companyName ?? 'selected company'}"',
                style: const TextStyle(fontSize: 18, color: Color(0xFF37474F), fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_jobs.isEmpty && (_selectedEmployer == null || _selectedEmployer!.id == -1)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Icon(Icons.search, size: 50, color: Color(0xFF6B7A8F)),
              SizedBox(height: 10),
              Text(
                'Select a company from the dropdown to see available jobs.',
                style: TextStyle(fontSize: 18, color: Color(0xFF37474F), fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    int crossAxisCount = 1;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) crossAxisCount = 2;
    if (screenWidth > 900) crossAxisCount = 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: (screenWidth / crossAxisCount) / 280,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(Job job) {
    final imagePlaceholder = job.logo != null && job.logo!.isNotEmpty
        ? Image.network(
      job.logo!,
      height: 50,
      width: 50,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xFFECEFF1),
        child: Icon(Icons.business_center, size: 30, color: Color(0xFF90A4AE)),
      ),
    )
        : const CircleAvatar(
      radius: 25,
      backgroundColor: Color(0xFFECEFF1),
      child: Icon(Icons.business_center, size: 30, color: Color(0xFF90A4AE)),
    );

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for image + title + bookmark
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imagePlaceholder,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF37474F)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.companyName ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF78909C),
                            fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Color(0xFF90A4AE)),
                  onPressed: () {},
                ),
              ],
            ),

            const Divider(height: 20, color: Color(0xFFE0E0E0)),

            // Job description
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 10),

            // Chips (wrap on small screens)
            Wrap(
              spacing: 8,
              runSpacing: 5,
              children: [
                _buildInfoChip(Icons.paid, 'Tk ${job.salary.toStringAsFixed(0)}', const Color(0xFF81C784)),
                _buildInfoChip(Icons.work, job.jobType, const Color(0xFFFFB74D)),
                _buildInfoChip(Icons.location_on, job.locationName, const Color(0xFF64B5F6)),
              ],
            ),

            const SizedBox(height: 10),

            // Apply button (full width)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  'Apply Now',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _applyJob(job.id, job.employerId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7A8F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // Slightly more opaque
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 0.8), // Softer border
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}