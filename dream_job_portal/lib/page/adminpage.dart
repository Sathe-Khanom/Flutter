import 'package:flutter/material.dart';
// Assume AdminDashboardPage is in 'admin_dashboard_page.dart'

// Assuming AdminUsersPage, AdminSettingsPage etc. would be imported here

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0; // Current selected menu item index

  // List of screens to display in the body
  final List<Widget> _screens = [
    // 0: Your previously created Dashboard
    const Center(child: Text('Manage Employers Page')), // 1
    const Center(child: Text('Manage Job Seekers Page')), // 2
    const Center(child: Text('Settings Page')), // 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Close the drawer if it's open (only applies to mobile view)
    if (MediaQuery.of(context).size.width < 600) {
      Navigator.pop(context);
    }
  }

  // Helper widget for the main navigation menu (Drawer or Side Menu)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(0, Icons.dashboard, 'Dashboard'),
          _buildDrawerItem(1, Icons.business, 'Employers'),
          _buildDrawerItem(2, Icons.person_search, 'Job Seekers'),
          _buildDrawerItem(3, Icons.settings, 'Settings'),
          const Divider(),
          _buildDrawerItem(4, Icons.logout, 'Logout', isLogout: true),
        ],
      ),
    );
  }

  // Helper widget for individual drawer items
  Widget _buildDrawerItem(int index, IconData icon, String title, {bool isLogout = false}) {
    // Check if the item is currently selected (for styling)
    bool isSelected = _selectedIndex == index && !isLogout;

    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : (isSelected ? Colors.indigo : Colors.grey.shade700)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isLogout ? Colors.redAccent : (isSelected ? Colors.indigo : Colors.black),
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (isLogout) {
          // TODO: Implement your logout logic here
          print('User logged out');
        } else if (_selectedIndex != index) {
          _onItemTapped(index);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a small screen (mobile) or large screen (desktop/tablet)
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.indigo,
        elevation: 0,
        // Only show the menu button if it's a mobile view (using Drawer)
        automaticallyImplyLeading: isMobile,
      ),

      // On mobile, the side menu becomes a Drawer
      drawer: isMobile ? _buildDrawer(context) : null,

      // Body contains the current selected screen
      body: Row(
        children: [
          // On large screens, show the side menu permanently
          if (!isMobile)
            SizedBox(
              width: 250, // Fixed width for the side menu
              child: _buildDrawer(context),
            ),

          // Main content area (takes the remaining space)
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0: return 'Admin Dashboard';
      case 1: return 'Manage Employers';
      case 2: return 'Manage Job Seekers';
      case 3: return 'Settings';
      default: return 'Admin Panel';
    }
  }
}

