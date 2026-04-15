import 'package:flutter/material.dart';
import 'package:frontend/config/api_config.dart';
import '../models/student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(child: StudentDetailsView(student: student)),
    );
  }
}

class StudentDetailsView extends StatelessWidget {
  final Student student;
  final String generatedSql;

  const StudentDetailsView({
    super.key,
    required this.student,
    this.generatedSql = '',
  });

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF222222),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF333333), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.trim().isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111111),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_sectionTitle(title), ...children],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (generatedSql.isNotEmpty) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E4E4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generated SQL',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(generatedSql),
                ],
              ),
            ),
          ],

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111111), Color(0xFF222222)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white24,
                  backgroundImage:
                      student.photoUrl.isNotEmpty
                          ? NetworkImage(ApiConfig.getImageUrl(student.photoUrl))
                          : null,
                  child:
                      student.photoUrl.isEmpty
                          ? const Icon(
                            Icons.person,
                            size: 46,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 14),
                Text(
                  student.fullName.isNotEmpty
                      ? student.fullName
                      : 'Student Name',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  student.rollNo.isNotEmpty ? student.rollNo : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _miniBadge(
                      icon: Icons.school_outlined,
                      text: student.course,
                    ),
                    _miniBadge(
                      icon: Icons.account_tree_outlined,
                      text: student.branch,
                    ),
                    _miniBadge(
                      icon: Icons.groups_2_outlined,
                      text: student.section,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.badge_outlined,
                  label: 'Gender',
                  value: student.gender,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  value: student.dateOfBirth,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.call_outlined,
                  label: 'Student Mobile',
                  value: student.studentMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: student.email,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _sectionCard(
            title: 'Academic Details',
            children: [
              _detailRow('Roll Number', student.rollNo),
              _detailRow('Full Name', student.fullName),
              _detailRow('Course', student.course),
              _detailRow('Branch', student.branch),
              _detailRow('Section', student.section),
              _detailRow('Admission Date', student.admissionDate),
              _detailRow(
                'Course Completion Year',
                student.courseCompletionYear,
              ),
            ],
          ),

          _sectionCard(
            title: 'Personal Details',
            children: [
              _detailRow('Gender', student.gender),
              _detailRow('Date of Birth', student.dateOfBirth),
              _detailRow('Caste Category', student.casteCategory),
              _detailRow('Aadhar Number', student.aadharNo),
            ],
          ),

          _sectionCard(
            title: 'Family & Contact Information',
            children: [
              _detailRow('Father Name', student.fatherName),
              _detailRow('Mother Name', student.motherName),
              _detailRow('Parent Mobile', student.parentMobile),
              _detailRow('Student Mobile', student.studentMobile),
              _detailRow('Email', student.email),
            ],
          ),

          _sectionCard(
            title: 'Academic History',
            children: [
              _detailRow('SSC', student.ssc),
              _detailRow('Inter', student.inter),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBadge({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            text.trim().isEmpty ? '-' : text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}