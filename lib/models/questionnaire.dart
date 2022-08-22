class Questionnaire {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String objective;
  final int awaitAnswers;
  final String totalTime;
  final String? backgroundImage;
  final String type;

  Questionnaire(
      {required this.id,
      required this.name,
      required this.shortDescription,
      required this.longDescription,
      required this.objective,
      required this.awaitAnswers,
      required this.totalTime,
      this.backgroundImage, required
      this.type});

  Questionnaire.fromApi(Map map)
      : this(
            id: map['id'],
            name: map['name'],
            shortDescription: map['short_description'],
            longDescription: map['long_description'],
            objective: map['objective'],
            awaitAnswers: map['await_answers'],
            totalTime: map['total_time'],
            backgroundImage: map['background_image'],
            type: map['type']);
}

class Section {
  final int id;
  final int step;
  final String title;
  final String? icon;
  final String? shotDescription;
  final String? longDescription;
  final int questionnaire;
  List<Question>? questions;
  Section(
      {required this.id,
      required this.step,
      required this.title,
      this.icon,
      this.shotDescription,
      this.longDescription,
      required this.questionnaire});

  List<Question>? getQuestions(){
    return questions;
  }

  void setQuestions(List<Question> value){
    questions = value;
  }

  Section.fromApi(Map map)
      : this(
            id: map['id'],
            step: map['step'],
            title: map['title'],
            icon: map['icon'],
            shotDescription: map['short_description'],
            longDescription: map['long_description'],
            questionnaire: map['questionnaire']);
}

class Question {
  final int id;
  final String text;
  final String? description;
  final int? previousQuestion;
  final String? previousQuestionValue;
  final String type;
  final int section;

  Question(
      {required this.id,
      required this.text,
      this.previousQuestion,
      this.previousQuestionValue,
      required this.type,
      this.description,
      required this.section});

  Question.fromApi(Map map)
      : this(
            id: map['id'],
            text: map['text'],
            previousQuestion: map['previous_question'],
            previousQuestionValue: map['previous_question_value'],
            type: map['type'],
            description: map['description'],
            section: map['section']);

  Map toJson() => {
    'id': id,
    'text': text,
    'previous_question': previousQuestion,
    'previous_question_value': previousQuestionValue,
    'type': type,
    'description': description,
    'section': section
  };
}

class GenericQuestionnaireValue{
    final int id;
    final List<String> questionValue;
    final List<String> cardinal;
    final List<int>? answerScore;
    final bool hasScore;
    final int questionnaireId;
    final String questionType;

    GenericQuestionnaireValue({
      required this.id,
      required this.questionValue,
      required this.cardinal,
      this.answerScore,
      required this.hasScore,
      required this.questionnaireId,
      required this.questionType
    });

    GenericQuestionnaireValue.fromApi(Map map) : this(
      id: map['id'],
      questionValue: List<String>.from(map['question_value']),
      cardinal: List<String>.from(map['cardinal']),
      answerScore: List<int>.from(map['answer_score']),
      hasScore: map['has_score'],
      questionnaireId: map['questionnaire'],
      questionType: map['question_type']
    );
}