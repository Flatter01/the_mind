import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

class ProfileHeader extends StatelessWidget {
  final StudentModel student;
  final bool isDebtor;

  const ProfileHeader({super.key, required this.student, required this.isDebtor});

  String get _initials {
    final f = (student.firstName ?? '').isNotEmpty ? student.firstName![0] : '';
    final l = (student.lastName ?? '').isNotEmpty ? student.lastName![0] : '';
    return '$l$f'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Аватар
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFED6A2E).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text(_initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFFED6A2E)))),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${student.lastName ?? ''} ${student.firstName ?? ''}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: !isDebtor ? const Color(0xFF2ECC8A).withOpacity(0.12) : const Color(0xFFED6A2E).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        !isDebtor ? 'АКТИВНЫЙ' : 'ДОЛЖНИК',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: !isDebtor ? const Color(0xFF2ECC8A) : const Color(0xFFED6A2E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Телефон вместо ID
                Text(student.phone ?? '—', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                const SizedBox(height: 14),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.email_outlined, size: 16, color: Colors.white),
                      label: const Text('Написать', style: TextStyle(color: Colors.white, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit_outlined, size: 16, color: Colors.grey[700]),
                      label: Text('Редактировать', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: [
              _StatBadge(label: 'ПОСЕЩАЕМОСТЬ', value: '94%', valueColor: const Color(0xFFED6A2E)),
              const SizedBox(width: 16),
              _StatBadge(label: 'СРЕДНИЙ БАЛЛ', value: '4.8', valueColor: const Color(0xFFED6A2E)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatBadge({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: valueColor)),
      ],
    );
  }
}
