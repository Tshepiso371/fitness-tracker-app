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

  void search() {
    context.read<ExerciseSearchProvider>()
        .searchExercises(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseSearchProvider>();

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
                  onPressed: provider.isLoading ? null : search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),


              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (value == controller.text) {
                    search();
                  }
                });
              },

              onSubmitted: (_) => search(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (_) {

                  if (provider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (provider.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 50),
                        const SizedBox(height: 10),
                        Text(provider.error!),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: provider.retry,
                          child: const Text("Retry"),
                        )
                      ],
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
                            subtitle: Text(
                                "${e.muscle} • ${e.difficulty}"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(e.instructions),
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
                          "Search for exercises",
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