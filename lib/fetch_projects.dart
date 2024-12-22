import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Model class for Projects
class Project {
  final String title;
  final DateTime date;
  final String description;
  final List<String> skills;
  final String? repoUrl;

  Project({
    required this.title,
    required this.date,
    required this.description,
    required this.skills,
    this.repoUrl,
  });

  factory Project.fromGitHub(Map<String, dynamic> repo) {
    // Extract languages from the repository
    List<String> skills = [];
    if (repo['language'] != null) {
      skills.add(repo['language']);
    }

    // Add topics as skills if available
    if (repo['topics'] != null && repo['topics'] is List) {
      skills.addAll((repo['topics'] as List).cast<String>());
    }

    return Project(
      title: repo['name'],
      date: DateTime.parse(repo['created_at']),
      description: repo['description'] ?? 'No description provided',
      skills: skills,
      repoUrl: repo['html_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'description': description,
      'skills': skills,
      'repoUrl': repoUrl,
    };
  }
}

class GitHubService {
  final String baseUrl = 'https://api.github.com';
  late final String token;

  GitHubService() {
    // Load token from environment variables
    token = dotenv.env['GITHUB_TOKEN'] ?? '';
  }

  Future<List<Project>> fetchProjects(String username) async {
    if (token.isEmpty) {
      throw Exception('GitHub token not found in environment variables');
    }

    final reposUrl = Uri.parse('$baseUrl/users/$username/repos');
    final response = await http.get(
      reposUrl,
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.mercy-preview+json',
      },
    );

    if (response.statusCode == 200) {
      final List repos = json.decode(response.body);

      // Fetch languages for each repository
      List<Project> projects = [];
      for (var repo in repos) {
        // Fetch topics for the repository
        final topicsUrl = Uri.parse('$baseUrl/repos/$username/${repo['name']}/topics');
        final topicsResponse = await http.get(
          topicsUrl,
          headers: {
            'Authorization': 'token $token',
            'Accept': 'application/vnd.github.mercy-preview+json',
          },
        );

        if (topicsResponse.statusCode == 200) {
          final topicsData = json.decode(topicsResponse.body);
          repo['topics'] = topicsData['names'] ?? [];
        }

        projects.add(Project.fromGitHub(repo));
      }

      return projects;
    } else {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }
  }
}
