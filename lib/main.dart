import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FitnessHomePage(),
    );
  }
}

class Participant {
  String name;
  String exercise;
  int duration;
  int calories;

  Participant({
    required this.name,
    required this.exercise,
    required this.duration,
    required this.calories,
  });
}

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  List<Participant> participants = [];

  final nameController = TextEditingController();
  final exerciseController = TextEditingController();
  final durationController = TextEditingController();
  final caloriesController = TextEditingController();

  void addParticipant() {
    if (nameController.text.isEmpty ||
        exerciseController.text.isEmpty ||
        durationController.text.isEmpty ||
        caloriesController.text.isEmpty) {
      return;
    }

    setState(() {
      participants.add(
        Participant(
          name: nameController.text,
          exercise: exerciseController.text,
          duration: int.parse(durationController.text),
          calories: int.parse(caloriesController.text),
        ),
      );

      participants.sort(
        (a, b) => b.calories.compareTo(a.calories),
      );
    });

    nameController.clear();
    exerciseController.clear();
    durationController.clear();
    caloriesController.clear();
  }

  void deleteParticipant(int index) {
    setState(() {
      participants.removeAt(index);
    });
  }

  int get totalCalories =>
      participants.fold(0, (sum, p) => sum + p.calories);

  int get totalDuration =>
      participants.fold(0, (sum, p) => sum + p.duration);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Participant Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: exerciseController,
              decoration: const InputDecoration(
                labelText: "Exercise Type",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Duration (Minutes)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Calories Burned",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: addParticipant,
              child: const Text("Add Participant"),
            ),

            const SizedBox(height: 20),
                        Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            "Participants",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${participants.length}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            "Calories",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalCalories",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.green.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            "Minutes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalDuration",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Fitness Performance Graph",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: participants.isEmpty
                  ? const Center(
                      child: Text(
                        "Add participants to view graph",
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget:
                                  (value, meta) {
                                if (value.toInt() <
                                    participants.length) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    child: Text(
                                      participants[
                                              value.toInt()]
                                          .name,
                                      style:
                                          const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(
                          participants.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: participants[index]
                                    .calories
                                    .toDouble(),
                                width: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

participants.isEmpty
    ? const Text(
        "No participants added yet",
      )
    : ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          bool isWinner = index == 0;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  "${index + 1}",
                ),
              ),
              title: Text(
                participants[index].name,
              ),
              subtitle: Text(
                "${participants[index].exercise} • "
                "${participants[index].duration} min • "
                "${participants[index].calories} cal",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isWinner)
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                    ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      deleteParticipant(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
                ],
        ),
      ),
    );
  }
}
