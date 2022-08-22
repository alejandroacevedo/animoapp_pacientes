import 'package:animoapp_pacientes/models/questionnaire.dart';
import 'dart:convert';
class QuestionStatus {
  final Question? previous;
  final Question current;
  final Question? next;

  QuestionStatus({this.previous, required this.current, this.next});

  QuestionStatus.fromJson(Map map)
      : this(
            previous: map['previous'] != null ? Question.fromApi(map['previous']) : null,
            current: Question.fromApi(map['current']),
            next: map['next'] != null ? Question.fromApi(map['next']): null);

  toJson() => {'previous': previous?.toJson() , 'current': current.toJson(), 'next': next?.toJson()};
}
