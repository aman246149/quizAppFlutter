import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/quiz_model.dart';
import '../../viewmodel/quiz_viewmodel.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<QuestionResult> questionResults;

  const QuizResultScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.questionResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (score / total * 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildScoreCard(context, percentage),
          const SizedBox(height: 24),
          Expanded(
            child: _buildQuestionList(context),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, double percentage) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: score / total,
                  strokeWidth: 12,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: _getScoreColor(theme, percentage),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: _getScoreColor(theme, percentage),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$score/$total',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getScoreMessage(percentage),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Time taken: ${_formatDuration(
              questionResults
                  .firstWhere((r) => r.answerTime != null,
                      orElse: () => questionResults.first)
                  .startTime,
              questionResults
                  .lastWhere((r) => r.answerTime != null,
                      orElse: () => questionResults.last)
                  .answerTime,
            )}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questionResults.length,
      itemBuilder: (context, index) {
        final result = questionResults[index];
        return QuestionResultCard(
          result: result,
          questionNumber: index + 1,
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/quiz'),
                child: const Text('Try Again'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(ThemeData theme, double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(double percentage) {
    if (percentage >= 80) return 'Excellent! Keep up the great work! 🎉';
    if (percentage >= 60) return 'Good job! Room for improvement! 👍';
    return 'Keep practicing! You can do better! 💪';
  }

  String _formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Not attempted';
    final duration = end.difference(start);
    final seconds = duration.inSeconds;
    return '${seconds}s';
  }
}

class QuestionResultCard extends StatelessWidget {
  final QuestionResult result;
  final int questionNumber;

  const QuestionResultCard({
    Key? key,
    required this.result,
    required this.questionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = result.isCorrect;
    final readingMaterial = result.question.readingMaterial;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ExpansionTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question $questionNumber',
                  style: theme.textTheme.titleMedium,
                ),
                if (result.question.topic != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      result.question.topic!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                result.selectedOptionId == -1
                    ? 'Not attempted'
                    : 'Time taken: ${_formatDuration(result.startTime, result.answerTime)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: result.selectedOptionId == -1
                      ? theme.colorScheme.error
                      : null,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.question.description ?? '',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    ...result.question.options?.map((option) {
                          final isSelected =
                              option.id == result.selectedOptionId;
                          final isCorrectOption = option.isCorrect == true;
                          return _buildOptionItem(
                            context,
                            option,
                            isSelected,
                            isCorrectOption,
                          );
                        }) ??
                        [],
                    if (result.question.detailedSolution != null) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Detailed Solution',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: MarkdownBody(
                          data: result.question.detailedSolution!,
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: theme.textTheme.bodyMedium,
                            h1: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            h2: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            h3: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            listBullet: theme.textTheme.bodyMedium,
                            strong: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            em: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            blockquote: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            code: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              color: theme.colorScheme.secondary,
                            ),
                            codeblockPadding: const EdgeInsets.all(8),
                            blockquotePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            listIndent: 24,
                          ),
                          selectable: true,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                    // if (readingMaterial != null &&
                    //     readingMaterial.contentSections != null &&
                    //     readingMaterial.contentSections!.isNotEmpty) ...[
                    //   const SizedBox(height: 16),
                    //   const Divider(),
                    //   const SizedBox(height: 8),
                    //   Text(
                    //     'Reading Material',
                    //     style: theme.textTheme.titleMedium?.copyWith(
                    //       color: theme.colorScheme.primary,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   if (readingMaterial.keywords?.isNotEmpty ?? false) ...[
                    //     const SizedBox(height: 8),
                    //     SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: Row(
                    //         children: _buildKeywordChips(
                    //           context,
                    //           readingMaterial.keywords ?? '',
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    //   const SizedBox(height: 12),
                    //   Container(
                    //     padding: const EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       color: theme.colorScheme.primaryContainer
                    //           .withOpacity(0.1),
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(
                    //         color: theme.colorScheme.outline.withOpacity(0.2),
                    //       ),
                    //     ),
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         children:
                    //             readingMaterial.contentSections!.map((section) {
                    //           return Html(
                    //             data: section,
                    //             style: {
                    //               'body': Style(
                    //                 margin: Margins.zero,
                    //                 padding: HtmlPaddings.zero,
                    //               ),
                    //               'h1': Style.fromTextStyle(
                    //                 theme.textTheme.titleLarge!.copyWith(
                    //                   color: theme.colorScheme.primary,
                    //                 ),
                    //               ).copyWith(
                    //                 margin: Margins.only(bottom: 8),
                    //               ),
                    //               'h2': Style.fromTextStyle(
                    //                 theme.textTheme.titleMedium!.copyWith(
                    //                   color: theme.colorScheme.primary,
                    //                 ),
                    //               ).copyWith(
                    //                 margin: Margins.only(top: 16, bottom: 8),
                    //               ),
                    //               'p': Style.fromTextStyle(
                    //                 theme.textTheme.bodyMedium!,
                    //               ).copyWith(
                    //                 margin: Margins.only(bottom: 8),
                    //               ),
                    //               '.important': Style(
                    //                 color: theme.colorScheme.primary,
                    //               ),
                    //               '.highlight': Style(
                    //                 backgroundColor: theme
                    //                     .colorScheme.primaryContainer
                    //                     .withOpacity(0.3),
                    //                 padding:
                    //                     HtmlPaddings.symmetric(horizontal: 4),
                    //               ),
                    //               'strong': Style(
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //               'span': Style(
                    //                 display: Display.inline,
                    //               ),
                    //             },
                    //             shrinkWrap: true,
                    //           );
                    //         }).toList(),
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    Option option,
    bool isSelected,
    bool isCorrectOption,
  ) {
    final theme = Theme.of(context);
    Color? backgroundColor;
    Color? textColor;

    if (isSelected && isCorrectOption) {
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
    } else if (isSelected && !isCorrectOption) {
      backgroundColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red;
    } else if (isCorrectOption) {
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor?.withOpacity(0.5) ?? theme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? (isCorrectOption ? Icons.check_circle : Icons.cancel)
                : (isCorrectOption
                    ? Icons.check_circle_outline
                    : Icons.remove_circle_outline),
            color: textColor ?? theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              option.description ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                decoration: isSelected ? null : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Not attempted';
    final duration = end.difference(start);
    final seconds = duration.inSeconds;
    return '${seconds}s';
  }

  List<Widget> _buildKeywordChips(BuildContext context, String keywords) {
    try {
      final List<dynamic> keywordList = json.decode(keywords);
      return keywordList
          .map((keyword) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(
                    keyword.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class QuestionResult {
  final Question question;
  final int selectedOptionId;
  final bool isCorrect;
  final DateTime startTime;
  final DateTime? answerTime;

  QuestionResult({
    required this.question,
    required this.selectedOptionId,
    required this.isCorrect,
    required this.startTime,
    required this.answerTime,
  });
}
