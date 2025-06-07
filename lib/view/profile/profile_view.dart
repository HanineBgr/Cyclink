import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Color accentColor = Color(0xFF8EC5FC);

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/profile_avatar.png'), // Replace with your asset
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stefani Wong", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                        SizedBox(height: 4),
                        Text("Lose a Fat Program", style: TextStyle(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                      elevation: 0,
                    ),
                    child: Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 22),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ProfileStat(title: "Height", value: "180cm"),
                  _ProfileStat(title: "Weight", value: "65kg"),
                  _ProfileStat(title: "Age", value: "22yo"),
                ],
              ),
              SizedBox(height: 22),

              // Account Section
              _ProfileSection(
                title: "Account",
                items: [
                  _ProfileSectionItem(icon: Icons.person_outline, label: "Personal Data"),
                  _ProfileSectionItem(icon: Icons.emoji_events_outlined, label: "Achievement"),
                  _ProfileSectionItem(icon: Icons.history, label: "Activity History"),
                  _ProfileSectionItem(icon: Icons.bar_chart, label: "Workout Progress"),
                ],
              ),
              SizedBox(height: 18),

              // Notification Section
              _ProfileSection(
                title: "Notification",
                items: [
                  _ProfileSectionItem(
                    icon: Icons.notifications_outlined,
                    label: "Pop-up Notification",
                    trailing: Switch(
                      value: true,
                      onChanged: (v) {},
                      activeColor: accentColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // Other Section
              _ProfileSection(
                title: "Other",
                items: [
                  _ProfileSectionItem(icon: Icons.mail_outline, label: "Contact Us"),
                  _ProfileSectionItem(icon: Icons.privacy_tip_outlined, label: "Privacy Policy"),
                  _ProfileSectionItem(icon: Icons.settings_outlined, label: "Settings"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: Color(0xFF8EC5FC), fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.black45, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileSectionItem> items;
  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ...items.map((item) => item).toList(),
        ],
      ),
    );
  }
}

class _ProfileSectionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  const _ProfileSectionItem({required this.icon, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0, right: 0),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Color(0xFF8EC5FC)),
      ),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: trailing ??
          Icon(Icons.chevron_right, color: Colors.black26),
      onTap: () {},
    );
  }
}