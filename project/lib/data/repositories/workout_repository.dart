import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all workouts
  Future<List<Workout>> fetchWorkouts() async {
    final snapshot = await _firestore.collection('workout').get();
    return snapshot.docs
        .map((doc) => Workout.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Fetch favorite workouts for a specific user
  Future<List<Workout>> fetchFavoriteWorkouts(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final favorites = userDoc.data()?['favorites'] ?? [];
    final workouts = await Future.wait(
      favorites.map(
        (workoutId) => _firestore.collection('workout').doc(workoutId).get(),
      ),
    );
    return workouts.map((doc) => Workout.fromMap(doc.data()!, doc.id)).toList();
  }

  // Fetch my workouts for a specific user
  Future<List<Workout>> fetchMyWorkouts(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final myWorkouts = userDoc.data()?['myWorkouts'] ?? [];
    final workouts = await Future.wait(
      myWorkouts.map(
        (workoutId) => _firestore.collection('workout').doc(workoutId).get(),
      ),
    );
    return workouts.map((doc) => Workout.fromMap(doc.data()!, doc.id)).toList();
  }

  // Add workout to favorites for a specific user
  Future<void> addToFavorites(String userId, String workoutId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({
      'favorites': FieldValue.arrayUnion([workoutId]),
    });
  }

  // Remove workout from favorites for a specific user
  Future<void> removeFromFavorites(String userId, String workoutId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({
      'favorites': FieldValue.arrayRemove([workoutId]),
    });
  }

  // Add workout to my workouts for a specific user
  Future<void> addToMyWorkouts(String userId, String workoutId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({
      'myWorkouts': FieldValue.arrayUnion([workoutId]),
    });
  }

  // Remove workout from my workouts for a specific user
  Future<void> removeFromMyWorkouts(String userId, String workoutId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({
      'myWorkouts': FieldValue.arrayRemove([workoutId]),
    });
  }
}
