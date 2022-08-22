import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:animoapp_pacientes/models/questionnaire.dart' as models;

Future<List<models.Questionnaire>?> fetchQuestionnaires() async {
  final response =
  await http.get(Uri.parse('http://10.0.2.2:8000/core/questionnaires/'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    List<models.Questionnaire> lst = <models.Questionnaire>[];
    data.forEach((element) {
      models.Questionnaire q = models.Questionnaire.fromApi(element);
      lst.add(q);
    });

    return lst;
  } else {
    print(response.statusCode);
    return null;
  }
}

Future<List<models.Section>?> fetchSections(
    {required int questionnaireId}) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8000/core/questionnaires/$questionnaireId/sections/'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    List<models.Section> lst = <models.Section>[];
    data.forEach((element) {
      models.Section s = models.Section.fromApi(element);
      lst.add(s);
    });

    return lst;
  } else {
    print(response.statusCode);
    return null;
  }
}

Future<List<models.Question>?> fetchQuestions(
    {required int questionnaireId}) async {
  final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/core/questionnaires/$questionnaireId/questions/'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    List<models.Question> lst = <models.Question>[];
    data.forEach((element) {
      models.Question s = models.Question.fromApi(element);
      lst.add(s);
    });

    return lst;
  } else {
    print(response.statusCode);
    return null;
  }
}

Future<models.GenericQuestionnaireValue?> fetchGenericQuestionValue(
    {required int questionnaireId}) async {
  final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/core/questionnaires/$questionnaireId/generic-values/'));
  if (response.statusCode == 200) {
    dynamic data = jsonDecode(utf8.decode(response.bodyBytes));

    return models.GenericQuestionnaireValue
        .fromApi(data);
  } else {
    print(response.statusCode);
    return null;
  }
}
