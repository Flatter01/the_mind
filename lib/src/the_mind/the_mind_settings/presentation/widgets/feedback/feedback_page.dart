import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Feedback от студентов",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              itemCount: feedbackList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = feedbackList[index];
                return _FeedbackCard(item: item);
              },
            ),
          ),
        ),
      ],
    );
  }
}
class _FeedbackCard extends StatelessWidget {
  final StudentFeedback item;

  const _FeedbackCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.bgColor,
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Имя + телефон
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.name} ${item.surname}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                item.phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Feedback
          Text(
            item.feedback,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
class StudentFeedback {
  final String name;
  final String surname;
  final String phone;
  final String feedback;

  StudentFeedback({
    required this.name,
    required this.surname,
    required this.phone,
    required this.feedback,
  });
}
final List<StudentFeedback> feedbackList = [
  StudentFeedback(
    name: "Ali",
    surname: "Karimov",
    phone: "+998 90 123 45 67",
    feedback: "Очень хороший курс, начал лучше понимать Flutter и Bloc.",
  ),
  StudentFeedback(
    name: "Madina",
    surname: "Rasulova",
    phone: "+998 93 555 22 11",
    feedback: "Хотелось бы больше практических заданий и живых примеров.",
  ),
  StudentFeedback(
    name: "Jasur",
    surname: "Toshmatov",
    phone: "+998 99 777 88 66",
    feedback: "Все понятно объясняют, особенно понравились разборы проектов.",
  ),
];
