import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/exercise_search_provider.dart';

class ExerciseSearchScreen extends StatefulWidget {
  const ExerciseSearchScreen({super.key});

  @override
  State<ExerciseSearchScreen> createState() =>
      _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search(String text) {
    if (text.trim().isEmpty) return;
    context.read<ExerciseSearchProvider>().searchExercises(text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseSearchProvider>();

    final commonMuscles = [
      'Chest', 'Biceps', 'Triceps', 'Back', 'Legs', 'Abs', 'Shoulders'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Exercises"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search muscle (e.g. biceps)",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => search(controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) => search(value),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: commonMuscles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final muscle = commonMuscles[index];
                  return ActionChip(
                    label: Text(muscle),
                    onPressed: () {
                      controller.text = muscle;
                      search(muscle);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, size: 50, color: Colors.orange),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              provider.error!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.hasResults) {
                    return ListView.builder(
                      itemCount: provider.results.length,
                      itemBuilder: (_, i) {
                        final e = provider.results[i];

                        return Card(
                          child: ExpansionTile(
                            title: Text(e.name),
                            subtitle: Text("${e.muscle} • ${e.difficulty}"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Instructions:", 
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(e.instructions),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "Search for exercises by muscle group",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
