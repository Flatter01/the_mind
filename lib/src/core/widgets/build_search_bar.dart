import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class BuildSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller; // <--- добавили

  const BuildSearchBar({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            onChanged: onChanged, // 👈 ВАЖНО
            controller: controller,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9DA4AE)),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Color(0xFF9DA4AE),
                size: 22,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
