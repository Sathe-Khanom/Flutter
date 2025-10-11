// import 'package:flutter/material.dart';
//
// class AdminDashboard extends StatelessWidget {
//   final int totalJobs;
//   final int totalSeekers;
//   final int totalEmployers;
//   final int totalApplications;
//   final int totalMessages;
//   final int totalLocations;
//   final int totalCategories;
//   final int totalUser;
//
//   const AdminDashboard({
//     super.key,
//     required this.totalJobs,
//     required this.totalSeekers,
//     required this.totalEmployers,
//     required this.totalApplications,
//     required this.totalMessages,
//     required this.totalLocations,
//     required this.totalCategories,
//     required this.totalUser,
//   });
//
//   Widget _buildCard(String title, int value, List<Color> gradientColors, IconData icon) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: gradientColors.last.withOpacity(0.6),
//             offset: const Offset(0, 6),
//             blurRadius: 12,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 40, color: Colors.white.withOpacity(0.9)),
//           const SizedBox(height: 16),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//               letterSpacing: 1.1,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value.toString(),
//             style: const TextStyle(
//               fontSize: 36,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Responsive grid: 3 cards per row on wide screens, 1 per row on narrow screens
//     final isWideScreen = MediaQuery.of(context).size.width > 900;
//     final crossAxisCount = isWideScreen ? 3 : 1;
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: const Text('Admin Dashboard'),
//         centerTitle: true,
//         elevation: 6,
//         shadowColor: Colors.deepPurpleAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Welcome Admin 👋',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple,
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 24,
//                 mainAxisSpacing: 24,
//                 childAspectRatio: 1.3,
//                 children: [
//                   _buildCard('Total Jobs', totalJobs, [Colors.blue.shade700, Colors.blue.shade400], Icons.work_outline),
//                   _buildCard('Total Seekers', totalSeekers, [Colors.green.shade700, Colors.green.shade400], Icons.people_outline),
//                   _buildCard('Employers', totalEmployers, [Colors.red.shade700, Colors.red.shade400], Icons.business_center_outlined),
//
//                   _buildCard('Applications', totalApplications, [Colors.deepOrange.shade700, Colors.deepOrange.shade400], Icons.assignment_outlined),
//                   _buildCard('Messages', totalMessages, [Colors.indigo.shade700, Colors.indigo.shade400], Icons.message_outlined),
//                   _buildCard('Locations', totalLocations, [Colors.teal.shade700, Colors.teal.shade400], Icons.location_on_outlined),
//
//                   _buildCard('Categories', totalCategories, [Colors.purple.shade700, Colors.purple.shade400], Icons.category_outlined),
//                   _buildCard('Total Users', totalUser, [Colors.pink.shade700, Colors.pink.shade400], Icons.person_outline),
//                   // You can add an empty container for layout consistency if you want
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
