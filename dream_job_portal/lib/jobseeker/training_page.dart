import 'package:flutter/material.dart';

import '../entity/training.dart';
import '../service/training_service.dart';


class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final TrainingService _trainingService = TrainingService();
  late Future<List<Training>> _trainingFuture;

  @override
  void initState() {
    super.initState();
    _trainingFuture = _trainingService.getTrainings();
  }

  Future<void> _refresh() async {
    setState(() {
      _trainingFuture = _trainingService.getTrainings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Trainings')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Training>>(
          future: _trainingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No trainings available.'));
            }

            final trainings = snapshot.data!;

            return ListView.builder(
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final training = trainings[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(training.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Institute: ${training.institute}'),
                        Text('Duration: ${training.duration}'),
                        Text('Description: ${training.description}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
