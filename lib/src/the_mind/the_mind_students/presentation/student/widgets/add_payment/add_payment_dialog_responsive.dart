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
  String search = "";
  StudentModel? selectedStudent;
  String selectedPaymentMethod = "cash";
  bool _isLoading = false;

  final amountController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Валидация
    if (selectedStudent == null) {
      _showError("Talabani tanlang");
      return;
    }
    if (selectedStudent!.groupId == null || selectedStudent!.groupId!.isEmpty) {
      _showError("Bu talabada guruh yo'q");
      return;
    }
    if (amountController.text.trim().isEmpty) {
      _showError("Summani kiriting");
      return;
    }
    if (selectedDate == null) {
      _showError("Sanani tanlang");
      return;
    }

    setState(() => _isLoading = true);

    final d = selectedDate!;
    final paymentMonth =
        "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    try {
      // await context.read<PaymentCubit>().createPayment(
      //   student: selectedStudent!.id,
      //   group: selectedStudent!.groupId!,       // ← UUID String
      //   administrator: "3fa85f64-5717-4562-b3fc-2c963f66afa6", // ← токендан олиш керак
      //   amount: amountController.text.trim(),
      //   payWith: selectedPaymentMethod,
      //   paymentMonth: paymentMonth,
      //   checkGiven: true,
      // );

      if (!mounted) return;

      // PaymentSuccess эмитланди — dialog ёп
      final state = context.read<PaymentCubit>().state;
      if (state is PaymentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("To'lov muvaffaqiyatli saqlandi!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (state is PaymentError) {
        _showError(state.message);
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.students.where((s) {
      final full =
          "${s.lastName ?? ''} ${s.firstName ?? ''} ${s.phone ?? ''} ${s.groupName ?? ''}"
              .toLowerCase();
      return full.contains(search.toLowerCase());
    }).toList();

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          // BlocListener — фақат кузатиш учун, submit'да ҳам handle қиламиз
          if (state is PaymentError) {
            _showError(state.message);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── TITLE ──
                const Center(
                  child: Text(
                    "To'lov kiritish",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 20),

                // ── QIDIRUV ──
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Talabani qidirish...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => setState(() => search = v),
                ),
                const SizedBox(height: 12),

                // ── TALABALAR RO'YXATI ──
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text("Talaba topilmadi",
                              style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final s = filtered[i];
                            final isSelected = selectedStudent?.id == s.id;
                            return ListTile(
                              onTap: () =>
                                  setState(() => selectedStudent = s),
                              selected: isSelected,
                              selectedTileColor:
                                  const Color(0xFFED6A2E).withOpacity(0.08),
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? const Color(0xFFED6A2E)
                                    : Colors.grey.shade200,
                                child: Text(
                                  (s.firstName ?? '?')[0].toUpperCase(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                "${s.lastName ?? ''} ${s.firstName ?? ''}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "${s.phone ?? ''} • ${s.groupName ?? 'Guruhsiz'}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Color(0xFFED6A2E))
                                  : null,
                            );
                          },
                        ),
                ),

                // ── БАЛАНС ──
                if (selectedStudent != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          "Joriy balans: ${selectedStudent!.balance} so'm",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── TO'LOV TURI ──
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "To'lov turi",
                    prefixIcon: const Icon(Icons.payment_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  value: selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(value: "cash", child: Text("Naqd pul")),
                    DropdownMenuItem(value: "card", child: Text("Karta")),
                    DropdownMenuItem(
                        value: "transfer", child: Text("O'tkazma")),
                  ],
                  onChanged: (v) =>
                      setState(() => selectedPaymentMethod = v ?? "cash"),
                ),

                const SizedBox(height: 16),

                // ── SUMMA ──
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "To'lov summasi (so'm)",
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                // ── SANA ──
                InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(now.year + 1),
                      initialDate: now,
                    );
                    if (date != null) setState(() => selectedDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate == null
                              ? "To'lov sanasini tanlang"
                              : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: selectedDate == null
                                ? Colors.black45
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── BUTTONS ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: const Text("Bekor qilish"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text("Saqlash",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}