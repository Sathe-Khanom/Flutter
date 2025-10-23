import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Eita dorkar

// ------------------------------------------------
// CORE GENERATOR FUNCTION (FINAL UPDATED)
// ------------------------------------------------
Future<void> generateAndPrintCV(Map<String, dynamic> profile) async {
  final pdf = pw.Document();

  // ⭐️ FONT LOADING FOR UNICODE SUPPORT
  final font = await PdfGoogleFonts.robotoRegular();
  final boldFont = await PdfGoogleFonts.robotoBold();

  // 1. Photo URL set up
  final String baseUrl = "http://localhost:8085/images/jobSeeker/";
  final String? photoName = profile['photo'];
  final String? photoUrl = (photoName != null && photoName.isNotEmpty)
      ? "$baseUrl$photoName"
      : null;

  // 2. Fetch Image bytes asynchronously
  final Uint8List? imageBytes = await _fetchImageBytes(photoUrl);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      // ⭐️ FONT THEME SETTING
      theme: pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      ),
      build: (pw.Context context) {
        final summery = profile['summery']?.isNotEmpty == true ? profile['summery'][0] : null;

        return [
          // Header (Name, Contact Details, Photo)
          _buildPdfHeaderWithPhoto(profile, imageBytes),
          pw.Divider(height: 15, color: PdfColors.grey700),

          // 1. Career Objective
          if (summery != null && summery['description'] != null)
            ...[
              _buildPdfSectionTitle('Career Objective'),

              pw.Divider(height:5, color: PdfColors.grey700),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  summery['description'],
                  textAlign: pw.TextAlign.justify,
                ),
              ),
            ],

          // 2. Training Section
          if (profile['trainings'] != null && profile['trainings'].isNotEmpty)
            ...[
              _buildPdfSectionTitle('Trainings & Certifications'),
              pw.Divider(height: 5, color: PdfColors.grey700),

              ..._buildPdfTrainingsSection(profile['trainings']),
              pw.SizedBox(height: 10),
            ],

          // 3. Education Section
          _buildPdfSectionTitle('Education'),
          pw.Divider(height: 5, color: PdfColors.grey700),

          ..._buildPdfEducationSection(profile['educations']),
          pw.SizedBox(height: 10),


          // 4. Experience Section
          _buildPdfSectionTitle('Experience'),
          pw.Divider(height: 5, color: PdfColors.grey700),
          ..._buildPdfExperienceSection(profile['experiences']),
          pw.SizedBox(height: 10),

          // 5. Extracurricular Section
          if (profile['extracurriculars'] != null && profile['extracurriculars'].isNotEmpty)
            ...[
              _buildPdfSectionTitle('Extracurricular Activities'),
              pw.Divider(height: 5, color: PdfColors.grey700),
              // ⭐️ Eikhane notun method call hoche
              ..._buildPdfExtracurricularSection(profile['extracurriculars']),
              pw.SizedBox(height: 10),
            ],

          // 6. Key Skills Section
          _buildPdfSectionTitle('Key Skills'),
          pw.Divider(height: 5, color: PdfColors.grey700),
          _buildPdfSkillsSection(profile['skills']),
          pw.SizedBox(height: 10),

          // 7. Languages Section
          _buildPdfSectionTitle('Languages'),
          pw.Divider(height: 5, color: PdfColors.grey700),
          _buildPdfLanguagesSection(profile['languages']),
          pw.SizedBox(height: 10),

          // 8. Hobbies Section
          if (profile['hobbies'] != null && profile['hobbies'].isNotEmpty)
            ...[
              _buildPdfSectionTitle('Hobbies'),
              pw.Divider(height: 5, color: PdfColors.grey700),
              _buildPdfHobbiesSection(profile['hobbies']),
              pw.SizedBox(height: 10),
            ],

          // 9. Reference Section
          if (profile['refferences'] != null && profile['refferences'].isNotEmpty)
            ...[
              _buildPdfSectionTitle('References'),
              pw.Divider(height: 5, color: PdfColors.grey700),
              ..._buildPdfReferencesSection(profile['refferences']),
              pw.SizedBox(height: 10),
            ],

          // 10. Personal Information (Last)
          if (summery != null)
            ..._buildPdfSummarySection(summery, profile),

        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// ------------------------------------------------
// HELPER FUNCTIONS (UNCHANGED, BUT INCLUDED FOR COMPLETENESS)
// ------------------------------------------------

// Image Fetching
Future<Uint8List?> _fetchImageBytes(String? photoUrl) async {
  if (photoUrl == null || photoUrl.isEmpty) return null;
  try {
    final response = await http.get(Uri.parse(photoUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
  } catch (e) {
    return null;
  }
  return null;
}

// Header with Photo
pw.Widget _buildPdfHeaderWithPhoto(Map<String, dynamic> profile, Uint8List? imageBytes) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              profile['name'] ?? 'Unknown',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.purple800),
            ),
            pw.SizedBox(height: 5),
            pw.Text('Phone: ${profile['phone'] ?? 'N/A'}'),
            pw.Text('Email: ${profile['user']?['email'] ?? 'N/A'}'),
            pw.Text('Address: ${profile['address'] ?? 'N/A'}'),
          ],
        ),
      ),
      if (imageBytes != null)
        pw.Container(
          width: 75,
          height: 75,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: PdfColors.purple800, width: 2),
          ),
          child: pw.ClipOval(
            child: pw.Image(
              pw.MemoryImage(imageBytes),
              fit: pw.BoxFit.cover,
            ),
          ),
        ),
    ],
  );
}

// Section Title
pw.Widget _buildPdfSectionTitle(String title) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
    child: pw.Text(
      title.toUpperCase(),
      style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
    ),
  );
}

// Helper for single row detail (for cleaner look)
pw.Widget _buildDetailRow(String label, dynamic value) {
  final displayValue = value?.toString() ?? "N/A";
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.SizedBox(
          width: 100, // Fixed width for label for alignment
          child: pw.Text("$label:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(child: pw.Text(displayValue)),
      ],
    ),
  );
}


// UPDATED Personal Details (Column Format with New Fields)
List<pw.Widget> _buildPdfSummarySection(Map<String, dynamic> summary, Map<String, dynamic> profile) {
  return [
    _buildPdfSectionTitle('Personal Details'),

    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildDetailRow("Father's Name", summary['fatherName']),
        _buildDetailRow("Mother's Name", summary['motherName']),

        _buildDetailRow("Date of Birth", profile['dateOfBirth']),
        _buildDetailRow("Gender", profile['gender']),
        _buildDetailRow("Nationality", summary['nationality']),
        _buildDetailRow("Religion", summary['religion']),

        _buildDetailRow("NID", summary['nid']),
        _buildDetailRow("Blood Group", summary['bloodGroup']),
        _buildDetailRow("Height", summary['height']),
        _buildDetailRow("Weight", summary['weight']),
      ],
    ),
    pw.SizedBox(height: 8),
  ];
}

// Education Section
List<pw.Widget> _buildPdfEducationSection(List<dynamic>? educations) {
  if (educations == null) return [];
  return List.generate(educations.length, (i) {
    final edu = educations[i];
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "${edu['level']} - ${edu['institute']}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
          ),
          pw.Text("${edu['board'] ?? 'N/A'}, ${edu['year']}"),
          pw.Text("Result: ${edu['result']}"),
        ],
      ),
    );
  });
}

// Experience Section
List<pw.Widget> _buildPdfExperienceSection(List<dynamic>? experiences) {
  if (experiences == null) return [];
  return List.generate(experiences.length, (i) {
    final exp = experiences[i];
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "${exp['position']} at ${exp['company']}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text("${exp['fromDate'] ?? 'N/A'} to ${exp['toDate'] ?? 'N/A'}"),
          pw.Text(exp['description'] ?? '', style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  });
}

// Training Section
List<pw.Widget> _buildPdfTrainingsSection(List<dynamic>? trainings) {
  if (trainings == null || trainings.isEmpty) return [];
  return List.generate(trainings.length, (i) {
    final tr = trainings[i];
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        children: [
          pw.Container(width: 4, height: 4, decoration: const pw.BoxDecoration(color: PdfColors.black, shape: pw.BoxShape.circle)),
          pw.SizedBox(width: 5),
          pw.Text(
            "${tr['title'] ?? 'N/A'} (${tr['institute'] ?? 'N/A'}) - ${tr['duration'] ?? 'N/A'}",
          ),
        ],
      ),
    );
  });
}

// Skills Section
pw.Widget _buildPdfSkillsSection(List<dynamic>? skills) {
  if (skills == null || skills.isEmpty) return pw.SizedBox();
  return pw.Wrap(
    spacing: 8,
    runSpacing: 4,
    children: List.generate(skills.length, (i) {
      final skill = skills[i];
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: pw.BoxDecoration(
            color: PdfColors.purple50,
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: PdfColors.purple200, width: 0.5)
        ),
        child: pw.Text("${skill['name']} (${skill['level']})", style: const pw.TextStyle(fontSize: 10)),
      );
    }),
  );
}

// Languages Section
pw.Widget _buildPdfLanguagesSection(List<dynamic>? languages) {
  if (languages == null || languages.isEmpty) return pw.SizedBox();
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: List.generate(languages.length, (i) {
      final lang = languages[i];
      return pw.Text("• ${lang['name']} (${lang['proficiency']})", style: const pw.TextStyle(lineSpacing: 2));
    }),
  );
}

// Hobbies Section
pw.Widget _buildPdfHobbiesSection(List<dynamic>? hobbies) {
  if (hobbies == null || hobbies.isEmpty) return pw.SizedBox();
  final hobbyNames = hobbies.map((h) => h['name']).whereType<String>().toList();
  if (hobbyNames.isEmpty) return pw.SizedBox();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
          hobbyNames.join(', '),
          style: const pw.TextStyle(fontSize: 10)
      ),
    ],
  );
}

// Extracurricular Section
List<pw.Widget> _buildPdfExtracurricularSection(List<dynamic>? extracurriculars) {
  // Check if data is null or empty
  if (extracurriculars == null || extracurriculars.isEmpty) return [];

  return List.generate(extracurriculars.length, (i) {
    final extra = extracurriculars[i];

    // **Note:** I am assuming the JSON data still contains 'organization',
    // as it is typical for extracurriculars. If not, use 'role'.
    final organizationOrRole = extra['organization'] ?? extra['role'] ?? 'N/A';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Title and Organization/Role (Bold)
          pw.Text(
            "${extra['title'] ?? 'Activity'} (${organizationOrRole})",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),

          // Role (if different from organization)
          if (extra['role'] != null && extra['role'].isNotEmpty && organizationOrRole != extra['role'])
            pw.Text("Role: ${extra['role']}"),

          // Description/Details
          pw.Text(
            extra['description'] ?? '',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  });
}

// Reference Section
List<pw.Widget> _buildPdfReferencesSection(List<dynamic>? references) {
  if (references == null) return [];
  // Ensure the bullet point here is correctly rendered by the loaded font
  return List.generate(references.length, (i) {
    final ref = references[i];
    return pw.Text("• ${ref['name']} (${ref['relation']}) - Contact: ${ref['contact']}", style: const pw.TextStyle(lineSpacing: 2));
  });
}