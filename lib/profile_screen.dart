import 'package:flutter/material.dart';
import 'package:fund_flow/login_screen.dart';
import 'package:fund_flow/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'FundFlow',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ), // Placeholder image
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                userSession.name ?? 'Robert Smith',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                userSession.email ?? 'robert.smith@example.com',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            ProfileMenuItem(
              icon: Icons.edit_outlined,
              text: 'Edit Profile',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.calendar_today_outlined,
              text: 'Set Monthly Budget',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.notifications_outlined,
              text: 'Notification Preferences',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.security_outlined,
              text: 'Privacy & Security',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.language_outlined,
              text: 'Language',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                userSession.name = null;
                userSession.email = null;
                userSession.password = null;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
