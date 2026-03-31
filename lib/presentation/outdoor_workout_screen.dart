import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/workout_tracking_provider.dart';

class OutdoorWorkoutScreen extends StatelessWidget {
  const OutdoorWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutTrackingProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_getTitle(provider.phase, provider.selectedActivity)),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (provider.phase == WorkoutPhase.idle) _buildActivitySelection(provider),
            if (provider.phase == WorkoutPhase.selecting) _buildReadyPhase(provider),
            if (provider.phase == WorkoutPhase.active) _buildActivePhase(provider),
            if (provider.phase == WorkoutPhase.finished) _buildFinishedPhase(provider),
          ],
        ),
      ),
    );
  }

  String _getTitle(WorkoutPhase phase, WorkoutActivityType type) {
    if (phase == WorkoutPhase.idle) return "Select Activity";
    if (phase == WorkoutPhase.finished) return "Workout Summary";
    return "${type.name[0].toUpperCase()}${type.name.substring(1)} Tracker";
  }

  Widget _buildActivitySelection(WorkoutTrackingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What are we doing today?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        _ActivityCard(
          type: WorkoutActivityType.walking,
          icon: Icons.directions_walk,
          title: "Walking",
          description: "A relaxed pace to clear your mind.",
          color: Colors.green,
          onTap: () {
            provider.setActivity(WorkoutActivityType.walking);
            provider.setPhase(WorkoutPhase.selecting);
          },
        ),
        _ActivityCard(
          type: WorkoutActivityType.running,
          icon: Icons.directions_run,
          title: "Running",
          description: "High intensity cardio for endurance.",
          color: Colors.orange,
          onTap: () {
            provider.setActivity(WorkoutActivityType.running);
            provider.setPhase(WorkoutPhase.selecting);
          },
        ),
        _ActivityCard(
          type: WorkoutActivityType.cycling,
          icon: Icons.directions_bike,
          title: "Cycling",
          description: "Speed through the trails on two wheels.",
          color: Colors.blue,
          onTap: () {
            provider.setActivity(WorkoutActivityType.cycling);
            provider.setPhase(WorkoutPhase.selecting);
          },
        ),
      ],
    );
  }

  Widget _buildReadyPhase(WorkoutTrackingProvider provider) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.selectedActivity == WorkoutActivityType.walking
                  ? Icons.directions_walk
                  : provider.selectedActivity == WorkoutActivityType.running
                      ? Icons.directions_run
                      : Icons.directions_bike,
              size: 80,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Ready for your ${provider.selectedActivity.name}?",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              provider.routeRecommendation,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pinkAccent.shade700, fontWeight: FontWeight.w500),
            ),
          ),
          const Text("GPS is ready to track your path.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(provider.error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: provider.isLoading ? null : provider.startWorkout,
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Start Now", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          TextButton(
            onPressed: () => provider.setPhase(WorkoutPhase.idle),
            child: const Text("Change Activity"),
          )
        ],
      ),
    );
  }

  Widget _buildActivePhase(WorkoutTrackingProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          provider.formattedTime,
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900, letterSpacing: -2),
        ),
        const Text("ELAPSED TIME", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatTile(label: "DIST", value: provider.formattedDistance),
            _StatTile(label: "PACE", value: provider.formattedPace),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomPaint(painter: RoutePainter(provider.routePoints)),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            onPressed: provider.isLoading ? null : provider.finishWorkout,
            child: const Text("FINISH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishedPhase(WorkoutTrackingProvider provider) {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 10),
        const Text("Workout Complete!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _SummaryRow(label: "Activity", value: provider.selectedActivity.name.toUpperCase()),
              const Divider(),
              _SummaryRow(label: "Time", value: provider.formattedTime),
              _SummaryRow(label: "Distance", value: provider.formattedDistance),
              _SummaryRow(label: "Avg Pace", value: provider.formattedPace),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text("Your Path", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CustomPaint(painter: RoutePainter(provider.routePoints)),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: provider.resetWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("DONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final WorkoutActivityType type;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  final List<Position> points;
  RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLon = points[0].longitude;
    double maxLon = points[0].longitude;
    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLon) minLon = p.longitude;
      if (p.longitude > maxLon) maxLon = p.longitude;
    }
    double latRange = maxLat - minLat;
    double lonRange = maxLon - minLon;
    if (latRange == 0) latRange = 0.0001;
    if (lonRange == 0) lonRange = 0.0001;
    Offset getOffset(Position p) {
      double x = (p.longitude - minLon) / lonRange * size.width;
      double y = size.height - ((p.latitude - minLat) / latRange * size.height);
      return Offset(x, y);
    }
    final paint = Paint()..color = Colors.pinkAccent..strokeWidth = 4.0..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(getOffset(points[i]), getOffset(points[i + 1]), paint);
    }
    canvas.drawCircle(getOffset(points.first), 6, Paint()..color = Colors.green);
    canvas.drawCircle(getOffset(points.last), 6, Paint()..color = Colors.red);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
