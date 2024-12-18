import 'package:flutter/material.dart';
import 'project_card.dart'; // Assuming ProjectCard is in a separate file.

class ProjectsGrid extends StatelessWidget {
  final int itemCount;

  const ProjectsGrid({
    Key? key,
    this.itemCount = 4, // Default to 4 items if not specified.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ProjectCard(
          title: 'Project ${index + 1}',
          description: 'Description for project ${index + 1}',
        );
      },
    );
  }
}
