import 'package:flutter/material.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  ExperiencePageState createState() => ExperiencePageState();
}

class ExperiencePageState extends State<ExperiencePage> {
  List<Map<String, dynamic>> mockData = [
    {
      "date": "January 2024",
      "events": ["Event 1", "Event 2", "Event 3", "Event 4", "Event 5", "Event 6"]
    },
    {
      "date": "February 2024",
      "events": ["Event 7", "Event 8", "Event 9", "Event 10", "Event 11", "Event 12"]
    },
    {
      "date": "March 2024",
      "events": ["Event 13", "Event 14", "Event 15", "Event 16", "Event 17", "Event 18"]
    },
    {
      "date": "Week 1, January 2024",
      "events": ["Event 19", "Event 20", "Event 21", "Event 22", "Event 23", "Event 24"]
    },
    {
      "date": "Week 2, January 2024",
      "events": ["Event 25", "Event 26", "Event 27", "Event 28", "Event 29", "Event 30"]
    },
    {
      "date": "Week 1, February 2024",
      "events": ["Event 31", "Event 32", "Event 33", "Event 34", "Event 35", "Event 36"]
    },
    {
      "date": "Week 2, February 2024",
      "events": ["Event 37", "Event 38", "Event 39", "Event 40", "Event 41", "Event 42"]
    },
    {
      "date": "Week 3, February 2024",
      "events": ["Event 43", "Event 44", "Event 45", "Event 46", "Event 47", "Event 48"]
    },
    {
      "date": "March 2024",
      "events": ["Event 49", "Event 50", "Event 51", "Event 52", "Event 53", "Event 54"]
    },
    {
      "date": "Week 4, February 2024",
      "events": ["Event 55", "Event 56", "Event 57", "Event 58", "Event 59", "Event 60"]
    }
  ];

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data when the user reaches the end
      // Add logic to fetch and add new dates to mockData list
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experience Timeline'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: mockData.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Text(
                  mockData[index]['date'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 200, // Adjust based on your content size
                child: ListView.builder(
                  itemCount: mockData[index]['events'].length,
                  itemBuilder: (context, subIndex) {
                    return ListTile(
                      title: Text(mockData[index]['events'][subIndex]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
