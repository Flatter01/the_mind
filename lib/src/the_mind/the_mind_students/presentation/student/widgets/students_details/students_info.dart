import 'package:flutter/material.dart';

class StudentsInfo {
  StudentsInfo(String s, String fullName);

  static Widget info(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: highlight ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
