import 'package:dio/dio.dart';
import 'models/api_exercise.dart';

class ExerciseApiRepository {
  final Dio _dio = Dio();

  static const String _baseUrl =
      'https://api.api-ninjas.com/v1/exercises';

  static const String _apiKey = 'iViXkCVwzH6vFHiNb3Eelnz3mikKnCsGYQXmkMJt';

  Future<List<ApiExercise>> searchExercises(String muscle) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'muscle': muscle},
        options: Options(headers: {'X-Api-Key': _apiKey}),
      );

      final List data = response.data;

      return data
          .map((e) => ApiExercise.fromJson(e))
          .toList();

    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out.');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Invalid API key.');
      }

      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded.');
      }

      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      }

      throw Exception('No internet connection.');
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}