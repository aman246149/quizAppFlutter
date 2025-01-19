// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) => QuizModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      topic: json['topic'] as String?,
      time: json['time'] as String?,
      isPublished: json['is_published'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      endTime: json['end_time'] as String?,
      negativeMarks: json['negative_marks'] as String?,
      correctAnswerMarks: json['correct_answer_marks'] as String?,
      shuffle: json['shuffle'] as bool?,
      showAnswers: json['show_answers'] as bool?,
      lockSolutions: json['lock_solutions'] as bool?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: (json['progress'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuizModelToJson(QuizModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'difficulty_level': instance.difficultyLevel,
      'topic': instance.topic,
      'time': instance.time,
      'is_published': instance.isPublished,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'duration': instance.duration,
      'end_time': instance.endTime,
      'negative_marks': instance.negativeMarks,
      'correct_answer_marks': instance.correctAnswerMarks,
      'shuffle': instance.shuffle,
      'show_answers': instance.showAnswers,
      'lock_solutions': instance.lockSolutions,
      'questions': instance.questions,
      'progress': instance.progress,
    };

ReadingMaterial _$ReadingMaterialFromJson(Map<String, dynamic> json) =>
    ReadingMaterial(
      id: (json['id'] as num?)?.toInt(),
      keywords: json['keywords'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      contentSections: (json['content_sections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      practiceMaterial: json['practice_material'] == null
          ? null
          : PracticeMaterial.fromJson(
              json['practice_material'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReadingMaterialToJson(ReadingMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keywords': instance.keywords,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'content_sections': instance.contentSections,
      'practice_material': instance.practiceMaterial,
    };

PracticeMaterial _$PracticeMaterialFromJson(Map<String, dynamic> json) =>
    PracticeMaterial(
      content:
          (json['content'] as List<dynamic>?)?.map((e) => e as String).toList(),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PracticeMaterialToJson(PracticeMaterial instance) =>
    <String, dynamic>{
      'content': instance.content,
      'keywords': instance.keywords,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      topic: json['topic'] as String?,
      detailedSolution: json['detailed_solution'] as String?,
      type: json['type'] as String?,
      isMandatory: json['is_mandatory'] as bool?,
      showInFeed: json['show_in_feed'] as bool?,
      pyqLabel: json['pyq_label'] as String?,
      topicId: (json['topic_id'] as num?)?.toInt(),
      readingMaterialId: (json['reading_material_id'] as num?)?.toInt(),
      fixedAt: json['fixed_at'] as String?,
      fixSummary: json['fix_summary'] as String?,
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      quizLevel: json['quiz_level'],
      questionFrom: json['question_from'] as String?,
      language: json['language'] as String?,
      photoUrl: json['photo_url'] as String?,
      photoSolutionUrl: json['photo_solution_url'] as String?,
      isSaved: json['is_saved'] as bool?,
      tag: json['tag'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      readingMaterial: json['reading_material'] == null
          ? null
          : ReadingMaterial.fromJson(
              json['reading_material'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'difficulty_level': instance.difficultyLevel,
      'topic': instance.topic,
      'detailed_solution': instance.detailedSolution,
      'type': instance.type,
      'is_mandatory': instance.isMandatory,
      'show_in_feed': instance.showInFeed,
      'pyq_label': instance.pyqLabel,
      'topic_id': instance.topicId,
      'reading_material_id': instance.readingMaterialId,
      'fixed_at': instance.fixedAt,
      'fix_summary': instance.fixSummary,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'quiz_level': instance.quizLevel,
      'question_from': instance.questionFrom,
      'language': instance.language,
      'photo_url': instance.photoUrl,
      'photo_solution_url': instance.photoSolutionUrl,
      'is_saved': instance.isSaved,
      'tag': instance.tag,
      'options': instance.options,
      'reading_material': instance.readingMaterial,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      questionId: (json['question_id'] as num?)?.toInt(),
      isCorrect: json['is_correct'] as bool?,
      unanswered: json['unanswered'] as bool?,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'question_id': instance.questionId,
      'is_correct': instance.isCorrect,
      'unanswered': instance.unanswered,
    };
