import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../viewmodel/quiz_viewmodel.dart';
import '../../core/utils/status.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/rocket_progress_bar.dart';
import '../../widgets/rocket_completion_animation.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _showingCompletion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset and load quiz when screen is mounted
      final viewModel = context.read<QuizViewModel>();
      viewModel.resetQuiz();
      viewModel.loadQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          return switch (viewModel.state) {
            OperationLoading() => Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('Item number $index as title'),
                        subtitle: const Text('Subtitle here'),
                        trailing: const Icon(Icons.ac_unit),
                      ),
                    );
                  },
                ),
              ).animate().fade(),
            OperationError() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Something went wrong'),
                    ElevatedButton(
                      onPressed: () => viewModel.loadQuiz(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            OperationSuccess() => _buildQuizContent(viewModel)
                .animate()
                .fade()
                .then()
                .shimmer(duration: const Duration(seconds: 2)),
            OperationInitial() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildQuizContent(QuizViewModel viewModel) {
    final question = viewModel.currentQuestion;
    if (question == null) {
      return const Center(child: Text('No questions available'));
    }

    final progress =
        (viewModel.currentQuestionIndex + 1) / viewModel.getTotalQuestions();

    return Stack(
      children: [
        Column(
          children: [
            RocketProgressBar(
              progress: progress,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${viewModel.currentQuestionIndex + 1}/${viewModel.getTotalQuestions()}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.description ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: question.options?.length ?? 0,
                        itemBuilder: (context, index) {
                          final option = question.options![index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: OptionCard(
                              option: option,
                              isSelected:
                                  viewModel.isOptionSelected(option.id!),
                              onTap: () => viewModel.answerQuestion(option.id!),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 60), // Space for floating buttons
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_showingCompletion)
          Center(
            child: RocketCompletionAnimation(
              onComplete: () {
                setState(() {
                  _showingCompletion = false;
                });
                _showResults(context, viewModel);
              },
            ),
          ),
        // Navigation Buttons
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Button - only show after first answer
              if (viewModel.hasAnsweredAny && !viewModel.isFirstQuestion)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'prev',
                    onPressed: viewModel.previousQuestion,
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                )
              else
                const SizedBox(),
              // Next/Finish Button - show based on mandatory status
              if (!(question.isMandatory ?? true) ||
                  viewModel.hasAnsweredCurrentQuestion)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'next',
                    onPressed: () {
                      if (viewModel.isLastQuestion) {
                        _showResults(context, viewModel);
                      } else {
                        viewModel.nextQuestion();
                      }
                    },
                    child: const Icon(Icons.arrow_forward_rounded),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showResults(BuildContext context, QuizViewModel viewModel) {
    context.go('/quiz-result', extra: {
      'score': viewModel.score,
      'total': viewModel.getTotalQuestions(),
      'results': viewModel.questionResults,
    });
  }
}

class OptionCard extends StatelessWidget {
  final dynamic option;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(
          option.description ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    )
        .animate(
          delay: const Duration(milliseconds: 800),
        )
        .shimmer(duration: const Duration(seconds: 2));
  }
}
