import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
class QuizModel {
  final int? id;
  final String? name;
  final String? title;
  final String? description;
  @JsonKey(name: 'difficulty_level')
  final String? difficultyLevel;
  final String? topic;
  final String? time;
  @JsonKey(name: 'is_published')
  final bool? isPublished;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final int? duration;
  @JsonKey(name: 'end_time')
  final String? endTime;
  @JsonKey(name: 'negative_marks')
  final String? negativeMarks;
  @JsonKey(name: 'correct_answer_marks')
  final String? correctAnswerMarks;
  final bool? shuffle;
  @JsonKey(name: 'show_answers')
  final bool? showAnswers;
  @JsonKey(name: 'lock_solutions')
  final bool? lockSolutions;
  final List<Question>? questions;
  final int? progress;

  QuizModel({
    this.id,
    this.name,
    this.title,
    this.description,
    this.difficultyLevel,
    this.topic,
    this.time,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.endTime,
    this.negativeMarks,
    this.correctAnswerMarks,
    this.shuffle,
    this.showAnswers,
    this.lockSolutions,
    this.questions,
    this.progress,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuizModelToJson(this);
}

@JsonSerializable()
class ReadingMaterial {
  final int? id;
  final String? keywords;
  final String? content;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'content_sections')
  final List<String>? contentSections;
  @JsonKey(name: 'practice_material')
  final PracticeMaterial? practiceMaterial;

  ReadingMaterial({
    this.id,
    this.keywords,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.contentSections,
    this.practiceMaterial,
  });

  factory ReadingMaterial.fromJson(Map<String, dynamic> json) =>
      _$ReadingMaterialFromJson(json);
  Map<String, dynamic> toJson() => _$ReadingMaterialToJson(this);
}

@JsonSerializable()
class PracticeMaterial {
  final List<String>? content;
  final List<String>? keywords;

  PracticeMaterial({
    this.content,
    this.keywords,
  });

  factory PracticeMaterial.fromJson(Map<String, dynamic> json) =>
      _$PracticeMaterialFromJson(json);
  Map<String, dynamic> toJson() => _$PracticeMaterialToJson(this);
}

@JsonSerializable()
class Question {
  final int? id;
  final String? description;
  @JsonKey(name: 'difficulty_level')
  final String? difficultyLevel;
  final String? topic;
  @JsonKey(name: 'detailed_solution')
  final String? detailedSolution;
  final String? type;
  @JsonKey(name: 'is_mandatory')
  final bool? isMandatory;
  @JsonKey(name: 'show_in_feed')
  final bool? showInFeed;
  @JsonKey(name: 'pyq_label')
  final String? pyqLabel;
  @JsonKey(name: 'topic_id')
  final int? topicId;
  @JsonKey(name: 'reading_material_id')
  final int? readingMaterialId;
  @JsonKey(name: 'fixed_at')
  final String? fixedAt;
  @JsonKey(name: 'fix_summary')
  final String? fixSummary;
  @JsonKey(name: 'created_by')
  final dynamic createdBy;
  @JsonKey(name: 'updated_by')
  final dynamic updatedBy;
  @JsonKey(name: 'quiz_level')
  final dynamic quizLevel;
  @JsonKey(name: 'question_from')
  final String? questionFrom;
  final String? language;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'photo_solution_url')
  final String? photoSolutionUrl;
  @JsonKey(name: 'is_saved')
  final bool? isSaved;
  final String? tag;
  final List<Option>? options;
  @JsonKey(name: 'reading_material')
  final ReadingMaterial? readingMaterial;

  Question({
    this.id,
    this.description,
    this.difficultyLevel,
    this.topic,
    this.detailedSolution,
    this.type,
    this.isMandatory,
    this.showInFeed,
    this.pyqLabel,
    this.topicId,
    this.readingMaterialId,
    this.fixedAt,
    this.fixSummary,
    this.createdBy,
    this.updatedBy,
    this.quizLevel,
    this.questionFrom,
    this.language,
    this.photoUrl,
    this.photoSolutionUrl,
    this.isSaved,
    this.tag,
    this.options,
    this.readingMaterial,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Option {
  final int? id;
  final String? description;
  @JsonKey(name: 'question_id')
  final int? questionId;
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;
  final bool? unanswered;

  Option({
    this.id,
    this.description,
    this.questionId,
    this.isCorrect,
    this.unanswered,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
