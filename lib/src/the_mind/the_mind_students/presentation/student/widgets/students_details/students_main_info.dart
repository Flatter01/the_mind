import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/student_actions_menu.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_info.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/title.dart';

class StudentsMainInfo extends StatefulWidget {
  final String fullName;
  final String gender;
  final String birthDate;
  final String phone;
  final String balance;
  final String currentGroup;
  final String abonementName;
  final int abonementPrice;
  final int discountAmount; // <-- теперь сумма
  final StudentStatus status;
  final String? deactivateReason;
  final String? deactivateDescription;

  const StudentsMainInfo({
    super.key,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.balance,
    required this.currentGroup,
    required this.abonementName,
    required this.abonementPrice,
    required this.discountAmount,
    required this.status,
    this.deactivateReason,
    this.deactivateDescription,
  });

  @override
  State<StudentsMainInfo> createState() => _StudentsMainInfoState();
}

class _StudentsMainInfoState extends State<StudentsMainInfo> {
  late int discountAmount;
  late StudentStatus status;
  String? deactivateReason;
  String? deactivateDescription;

  final TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    discountAmount = widget.discountAmount;
    status = widget.status;
    deactivateReason = widget.deactivateReason;
    deactivateDescription = widget.deactivateDescription;

    discountController.text = discountAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return StudentsCard.card(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Titles.title("Main Information"),
                const Spacer(),
                StudentActionsMenu(),
              ],
            ),
            const SizedBox(height: 16),

            StudentsInfo.info("Full name", widget.fullName),
            StudentsInfo.info("Gender", widget.gender),
            StudentsInfo.info("Birth date", widget.birthDate),
            StudentsInfo.info("Phone", widget.phone),

            const Divider(height: 30),

            StudentsInfo.info("Current group", widget.currentGroup),
            StudentsInfo.info("Balance", widget.balance, highlight: true),

            const SizedBox(height: 12),

            StudentsInfo.info("Abonement", widget.abonementName),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  "${widget.abonementPrice} UZS",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$finalPrice UZS",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text("Discount (UZS)"),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: "Enter discount amount",
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;

                      setState(() {
                        discountAmount = parsed > widget.abonementPrice
                            ? widget.abonementPrice
                            : parsed;
                      });
                    },
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            const Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            DropdownButtonFormField<StudentStatus>(
              value: status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                  value: StudentStatus.trial,
                  child: Text("🟡 Probniy dars"),
                ),
                DropdownMenuItem(
                  value: StudentStatus.active,
                  child: Text("🟢 Faol o'quvchi"),
                ),
                DropdownMenuItem(
                  value: StudentStatus.inactive,
                  child: Text("🔴 Faol emas"),
                ),
              ],
              onChanged: (v) async {
                if (v == null) return;

                if (v == StudentStatus.inactive) {
                  final result = await _showDeactivateDialog();
                  if (result == true) {
                    setState(() => status = v);
                  }
                } else {
                  setState(() {
                    status = v;
                    deactivateReason = null;
                    deactivateDescription = null;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            _statusBadge(),

            if (status == StudentStatus.inactive &&
                deactivateReason != null) ...[
              const SizedBox(height: 8),
              Text(
                "Reason: $deactivateReason",
                style: const TextStyle(color: Colors.red),
              ),
              if (deactivateDescription != null &&
                  deactivateDescription!.isNotEmpty)
                Text(
                  deactivateDescription!,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
            ],
          ],
        ),
      ),
    );
  }

  int get finalPrice {
    final result = widget.abonementPrice - discountAmount;
    return result < 0 ? 0 : result;
  }

  Future<bool?> _showDeactivateDialog() {
    final reasonController = TextEditingController();
    final descriptionController = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Deactivate student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.trim().isEmpty) return;

                deactivateReason = reasonController.text;
                deactivateDescription = descriptionController.text;

                Navigator.pop(context, true);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget _statusBadge() {
    late Color color;
    late String text;

    switch (status) {
      case StudentStatus.trial:
        color = Colors.orange;
        text = "Probniy dars";
        break;
      case StudentStatus.active:
        color = Colors.green;
        text = "Faol o'quvchi";
        break;
      case StudentStatus.inactive:
        color = Colors.red;
        text = "Faol emas";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
