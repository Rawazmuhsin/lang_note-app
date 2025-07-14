import 'package:flutter/material.dart';
import 'package:langnote/constants/theme_colors.dart';

class LanguageInputSection extends StatelessWidget {
  final String emoji;
  final String language;
  final String subtitle;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPrimary;

  const LanguageInputSection({
    super.key,
    required this.emoji,
    required this.language,
    required this.subtitle,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isPrimary
                  ? ThemeColors.primaryPurple.withOpacity(0.2)
                  : Colors.grey.shade200,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isPrimary
                    ? ThemeColors.primaryPurple.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: isPrimary ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isPrimary
                          ? ThemeColors.primaryPurple.withOpacity(0.1)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isPrimary
                            ? ThemeColors.primaryPurple.withOpacity(0.2)
                            : Colors.grey.shade200,
                  ),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: isPrimary ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isPrimary
                                ? ThemeColors.primaryPurple
                                : ThemeColors.textSecondary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: isPrimary ? 18 : 16,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color:
                      isPrimary
                          ? ThemeColors.primaryPurple
                          : ThemeColors.primaryBlue,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
