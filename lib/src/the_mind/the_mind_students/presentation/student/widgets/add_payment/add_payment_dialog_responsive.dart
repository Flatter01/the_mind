import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_stae.dart';

class AddPaymentDialogResponsive extends StatefulWidget {
  final List<StudentModel> students;

  const AddPaymentDialogResponsive({super.key, required this.students});

  @override
  State<AddPaymentDialogResponsive> createState() =>
      _AddPaymentDialogResponsiveState();
}

class _AddPaymentDialogResponsiveState
    extends State<AddPaymentDialogResponsive> {
  void _showError(BuildContext context, String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String search = "";
  StudentModel? selectedStudent;
  String? selectedPaymentMethod = "cash";

  final amountController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.students.where((s) {
      final full = "${s.lastName}${s.firstName} ${s.phone} ${s.groupName}"
          .toLowerCase();
      return full.contains(search.toLowerCase());
    }).toList();

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "To‘lov kiritish",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              // Поисковик
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Qidirish...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (v) => setState(() => search = v),
              ),

              const SizedBox(height: 16),

              // Список учеников
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final s = filtered[i];
                    return RadioListTile<StudentModel>(
                      value: s,
                      groupValue: selectedStudent,
                      onChanged: (v) => setState(() => selectedStudent = v),
                      title: Text(
                        "${s.lastName}${s.firstName} — ${s.groupName}",
                      ),
                      subtitle: Text(s.phone.toString()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Метод оплаты
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "To‘lov turi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedPaymentMethod,
                items: const [
                  DropdownMenuItem(value: "cash", child: Text("Naqd")),
                  DropdownMenuItem(value: "card", child: Text("Karta")),
                  DropdownMenuItem(value: "transfer", child: Text("O'tkazma")),
                ],
                onChanged: (v) => setState(() => selectedPaymentMethod = v),
              ),

              const SizedBox(height: 20),

              // Сумма
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "To‘lov summasi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Дата платежа
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(now.year + 1),
                    initialDate: now,
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 8),
                      Text(
                        selectedDate == null
                            ? "To‘lov sanasi"
                            : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Bekor qilish"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedStudent == null) {
                        _showError(context, "Talabani tanlang");
                        return;
                      }
                      if (selectedStudent!.groupId == null) {
                        _showError(context, "Bu talabada guruh yo'q");
                        return;
                      }
                      if (selectedPaymentMethod == null) {
                        _showError(context, "To'lov turini tanlang");
                        return;
                      }
                      if (amountController.text.isEmpty) {
                        _showError(context, "Summani kiriting");
                        return;
                      }
                      if (selectedDate == null) {
                        _showError(context, "Sanani tanlang");
                        return;
                      }

                      final cubit = context.read<PaymentCubit>();
                      final d = selectedDate!;
                      final paymentMonth =
                          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

                      await cubit.createPayment(
                        student: selectedStudent!.id,
                        group: selectedStudent!.groupId!,
                        administrator: "1",
                        amount: amountController.text,
                        payWith: selectedPaymentMethod!,
                        paymentMonth: paymentMonth,
                        checkGiven: true,
                      );

                      if (!mounted) return;
                      final state = cubit.state;
                      if (state is PaymentError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Saqlash"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
