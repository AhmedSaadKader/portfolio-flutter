import 'package:flutter/material.dart';
import 'skill_chip.dart'; // Assuming SkillChip is in a separate file.

class SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> skills;

  const SkillCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.skills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => SkillChip(label: skill)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
