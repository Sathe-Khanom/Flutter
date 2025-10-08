import 'package:flutter/material.dart';
import '../entity/employer.dart';
// Adjust path to your Employer model

class EmployerProfile extends StatelessWidget {
  final Employer employer;

  const EmployerProfile({Key? key, required this.employer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8085/images/employers/";
    final String? logoName = employer.logo;
    final String? logoUrl = (logoName != null && logoName.isNotEmpty)
        ? "$baseUrl$logoName"
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Profile"),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(logoUrl),
            const SizedBox(height: 24),
            _buildSectionTitle("Employer Info"),
            _buildInfoRow("Company Name", employer.companyName),
            _buildInfoRow("Industry Type", employer.industryType),
            _buildInfoRow("Website", employer.companyWebsite),
            _buildInfoRow("Address", employer.companyAddress),
            const SizedBox(height: 20),
            _buildSectionTitle("Contact Info"),
            _buildInfoRow("Contact Person", employer.contactPerson),
            _buildInfoRow("Email", employer.email),
            _buildInfoRow("Phone", employer.phoneNumber),
          ],
        ),
      ),
    );
  }

  // ------------------------
  // PROFILE HEADER
  // ------------------------
  Widget _buildProfileHeader(String? logoUrl) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 3),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
                  ? NetworkImage(logoUrl)
                  : const AssetImage('assets/images/default_company_logo.png') as ImageProvider,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            employer.companyName ?? 'Unknown Company',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            employer.email ?? 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // SECTION TITLE
  // ------------------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ------------------------
  // INFO ROW
  // ------------------------
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }
}
