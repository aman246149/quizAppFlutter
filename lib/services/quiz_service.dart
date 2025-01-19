import 'package:dio/dio.dart';
import '../models/quiz_model.dart';

class QuizService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<QuizModel> fetchQuiz() async {
    try {
      final response = await _dio.get(_baseUrl);
      return QuizModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load quiz: $e');
    }
  }
}
