import 'package:flutter/foundation.dart';
import 'package:user_app/core/routing/router.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import '../core/utils/status.dart';
import '../core/utils/snackbars.dart';
import '../view/quiz/quiz_result_screen.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  OperationState<QuizModel> _state = const OperationInitial();
  int _currentQuestionIndex = 0;
  int _score = 0;
  Map<int, int> _userAnswers = {};
  DateTime? _currentQuestionStartTime;
  List<QuestionResult> _questionResults = [];

  // Getters
  OperationState<QuizModel> get state => _state;
  QuizModel? get quiz => _state is OperationSuccess<QuizModel>
      ? (_state as OperationSuccess<QuizModel>).data
      : null;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isLastQuestion =>
      quiz?.questions != null &&
      _currentQuestionIndex >= (quiz!.questions!.length - 1);

  Question? get currentQuestion =>
      quiz?.questions != null && quiz!.questions!.isNotEmpty
          ? quiz!.questions![_currentQuestionIndex]
          : null;

  bool get isFirstQuestion => _currentQuestionIndex == 0;

  bool get hasAnsweredCurrentQuestion {
    return currentQuestion != null &&
        _userAnswers.containsKey(currentQuestion!.id);
  }

  List<QuestionResult> get questionResults => _questionResults;

  bool get hasAnsweredAny => _userAnswers.isNotEmpty;

  Future<void> loadQuiz() async {
    try {
      _state = const OperationLoading();
      notifyListeners();

      final quizData = await _quizService.fetchQuiz();
      _state = OperationSuccess(quizData);
      _currentQuestionIndex = 0;
      _score = 0;
      _userAnswers.clear();
      _questionResults.clear();
      _currentQuestionStartTime = DateTime.now();
    } catch (e) {
      _state = OperationError(
        message: 'Failed to load quiz',
        error: e,
      );
      SnackBars.showErrorSnackBar('Failed to load quiz: ${e.toString()}');
    }
    notifyListeners();
  }

  void answerQuestion(int optionId) {
    if (currentQuestion == null) return;

    // If this question has already been answered, don't update the score
    if (!_userAnswers.containsKey(currentQuestion!.id!)) {
      final selectedOption = currentQuestion!.options!
          .firstWhere((option) => option.id == optionId);
      final isCorrect = selectedOption.isCorrect == true;

      if (isCorrect) {
        _score++;
      }

      _questionResults.add(QuestionResult(
        question: currentQuestion!,
        selectedOptionId: optionId,
        isCorrect: isCorrect,
        startTime: _currentQuestionStartTime!,
        answerTime: DateTime.now(),
      ));
    }

    // Update the selected answer
    _userAnswers[currentQuestion!.id!] = optionId;

    notifyListeners();
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      final currentQuestionIsMandatory = currentQuestion?.isMandatory ?? true;

      // If question is not answered and not mandatory, add it to results
      if (!hasAnsweredCurrentQuestion && !currentQuestionIsMandatory) {
        _addQuestionResult(null, null);
      }

      if (!currentQuestionIsMandatory || hasAnsweredCurrentQuestion) {
        _currentQuestionIndex++;
        _currentQuestionStartTime = DateTime.now();
        notifyListeners();
      }
    }
  }

  bool isOptionSelected(int optionId) {
    return _userAnswers[currentQuestion?.id] == optionId;
  }

  bool? isAnswerCorrect(int questionId) {
    final selectedOptionId = _userAnswers[questionId];
    if (selectedOptionId == null) return null;

    final question = quiz?.questions?.firstWhere((q) => q.id == questionId);
    final selectedOption =
        question?.options?.firstWhere((o) => o.id == selectedOptionId);

    return selectedOption?.isCorrect;
  }

  int getTotalQuestions() => quiz?.questions?.length ?? 0;

  void previousQuestion() {
    if (!isFirstQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void resetQuiz() {
    if (_state is OperationSuccess<QuizModel>) {
      _currentQuestionIndex = 0;
      _score = 0;
      _userAnswers.clear();
      _questionResults.clear();
      _currentQuestionStartTime = DateTime.now();
      notifyListeners();
    }
  }

  void _addQuestionResult(bool? isCorrect, int? selectedOptionId) {
    if (currentQuestion == null || _currentQuestionStartTime == null) return;

    _questionResults.add(QuestionResult(
      question: currentQuestion!,
      selectedOptionId: selectedOptionId ?? -1, // -1 indicates unanswered
      isCorrect: isCorrect ?? false,
      startTime: _currentQuestionStartTime!,
      answerTime: DateTime.now(),
    ));
  }

  void _showResults() {
    final remainingQuestions =
        quiz?.questions?.skip(_currentQuestionIndex) ?? [];
    for (final question in remainingQuestions) {
      if (!(question.isMandatory ?? true) &&
          !_userAnswers.containsKey(question.id)) {
        _addQuestionResult(null, null);
      }
    }

    if (_questionResults.isEmpty) {
      SnackBars.showWarningSnackBar('Please answer at least one question');
      return;
    }

    router.go('/quiz-result', extra: {
      'score': score,
      'total': getTotalQuestions(),
      'results': _questionResults,
    });
  }
}
