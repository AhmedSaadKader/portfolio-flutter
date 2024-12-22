import 'package:flutter/material.dart';
import 'package:portfolio_flutter/custom_app_bar.dart';
import 'package:portfolio_flutter/draggable_scrollbar.dart';
import 'package:portfolio_flutter/fetch_projects.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

class PortfolioList extends StatefulWidget {
  const PortfolioList({super.key});

  @override
  State<PortfolioList> createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemScrollController _datesScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final ItemPositionsListener _datesPositionsListener = ItemPositionsListener.create();
  final TextEditingController _searchController = TextEditingController();
  bool _scrolling = false;
  String _searchQuery = '';
  final Set<String> _selectedSkills = {};
  int _currentIndex = 0;
  final GitHubService _githubService = GitHubService();
  late Future<List<Project>> _projectsFuture;

  List<Project> _allProjects = [];
  bool _sortAscending = false;

  Future<List<Project>> fetchAllProjects() async {
    try {
      final projects = await _githubService.fetchProjects('ahmedsaadkader');
      setState(() {
        _allProjects = projects;
      });
      return projects;
    } catch (e) {
      print('Error fetching projects: $e');
      throw e;
    }
  }

  List<Project> get filteredProjects {
    // First filter the projects
    var filtered = _allProjects.where((project) {
      final matchesSearch = project.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          project.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSkills = _selectedSkills.isEmpty || project.skills.any((skill) => _selectedSkills.contains(skill));

      return matchesSearch && matchesSkills;
    }).toList();

    // Then sort them by date
    filtered.sort((a, b) {
      return _sortAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
    });

    return filtered;
  }

  // Add a method to toggle sort direction
  void _toggleSortDirection() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  Set<String> get allSkills {
    return _allProjects.expand((project) => project.skills).toSet();
  }

  Text _labelBuilder(int pos) {
    if (pos < 0 || pos >= filteredProjects.length) {
      return const Text("");
    }
    final date = filteredProjects[pos].date;
    return Text(
      DateFormat.yMMMM().format(date),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _onScrollStateChanged(bool scrolling) {
    if (scrolling != _scrolling) {
      setState(() {
        _scrolling = scrolling;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _projectsFuture = fetchAllProjects();
    _itemPositionsListener.itemPositions.addListener(_onPositionChange);
  }

  void _onPositionChange() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstIndex = positions.first.index;
      if (firstIndex != _currentIndex) {
        setState(() {
          _currentIndex = firstIndex;
        });
        // Scroll the dates list to match the current position
        _datesScrollController.jumpTo(index: firstIndex);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Projects'),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading projects',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _projectsFuture = fetchAllProjects();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No projects found'),
            );
          }

          return Column(
            children: [
              // Search and Filter Bar
              Material(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: _toggleSortDirection,
                            icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                            label: Text(_sortAscending ? 'Oldest First' : 'Newest First'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search projects...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: allSkills.map((skill) {
                            final isSelected = _selectedSkills.contains(skill);
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                selected: isSelected,
                                label: Text(skill),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedSkills.add(skill);
                                    } else {
                                      _selectedSkills.remove(skill);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    DraggableScrollbar.semicircle(
                      controller: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      scrollStateListener: _onScrollStateChanged,
                      backgroundColor:
                          isDark ? Theme.of(context).primaryColor.withOpacity(0.7) : Theme.of(context).primaryColor,
                      labelTextBuilder: _labelBuilder,
                      labelConstraints: const BoxConstraints(maxHeight: 28),
                      scrollbarAnimationDuration: const Duration(milliseconds: 300),
                      scrollbarTimeToFade: const Duration(milliseconds: 1000),
                      child: ScrollablePositionedList.builder(
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) => ProjectCard(
                          project: filteredProjects[index],
                        ),
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                        padding: const EdgeInsets.only(right: 120, left: 16),
                      ),
                    ),
                    // Keep the date indicator list the same...
                    Positioned(
                      right: 30,
                      top: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.9),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                          ),
                          child: ScrollablePositionedList.builder(
                            itemCount: filteredProjects.length,
                            itemScrollController: _datesScrollController,
                            itemPositionsListener: _datesPositionsListener,
                            itemBuilder: (context, index) {
                              final date = filteredProjects[index].date;
                              return GestureDetector(
                                onTap: () {
                                  _itemScrollController.scrollTo(
                                    index: index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  color:
                                      _currentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                                  child: Text(
                                    DateFormat.yMMMM().format(date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
                                      color: _currentIndex == index ? Theme.of(context).primaryColor : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Date row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(project.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      project.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Skills
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (project.skills).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            skill.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
