import 'package:flutter/material.dart';
import 'package:maintainiq/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Estimate Complete!',
      'body': 'Your cost estimate is ready check the results',
      'icon': Icons.calculate_rounded,
      'color': AppColors.primary,
      'time': 'Right now',
      'read': false,
    },
    {
      'title': 'AI Chatbot Ready',
      'body': 'Ask Gemini AI any quetion',
      'icon': Icons.smart_toy_rounded,
      'color': AppColors.success,
      'time': 'Two minutes ago',
      'read': false,
    },
    {
      'title': 'PDF Report',
      'body': 'Your PDF report is ready to be Downloaded',
      'icon': Icons.picture_as_pdf_rounded,
      'color': AppColors.warning,
      'time': 'One hour ago',
      'read': true,
    },
    {
      'title': 'Welcome to MaintainIQ!',
      'body': 'Software maintenance cost estimate start.',
      'icon': Icons.waving_hand_rounded,
      'color': AppColors.primaryDark,
      'time': 'Today',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6358C8), Color(0xFF8B82E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications',
                      style: TextStyle(fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                    Text(' alerts',
                      style: TextStyle(fontSize: 13,
                        color: Colors.white70)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var n in _notifications) {
                        n['read'] = true;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Read all',
                      style: TextStyle(fontSize: 12,
                        color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primary, size: 38),
                      ),
                      const SizedBox(height: 16),
                      const Text('There is no notifications',
                        style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, i) {
                    final n = _notifications[i];
                    return GestureDetector(
                      onTap: () => setState(() => n['read'] = true),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: n['read']
                            ? AppColors.surface
                            : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: n['read']
                              ? AppColors.border
                              : AppColors.primary.withOpacity(0.3)),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8)],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46, height: 46,
                              decoration: BoxDecoration(
                                color: (n['color'] as Color)
                                  .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(n['icon'] as IconData,
                                color: n['color'] as Color, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(n['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: n['read']
                                            ? FontWeight.w500
                                            : FontWeight.bold,
                                          color: AppColors.textPrimary)),
                                      Text(n['time'],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary)),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(n['body'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.4)),
                                ],
                              ),
                            ),
                            if (!n['read'])
                              Container(
                                width: 8, height: 8,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}