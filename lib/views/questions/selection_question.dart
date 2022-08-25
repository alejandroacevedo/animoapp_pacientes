import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animoapp_pacientes/models/questionnaire.dart' as models;
import 'package:animoapp_pacientes/models/local_models_questionnaires.dart'
    as local_models;
import 'package:animoapp_pacientes/services/questionnaires_services.dart' as ds;
import 'package:localstorage/localstorage.dart';

class SelectQuestionPage extends StatefulWidget {
  final double progressLine;
  final String questionnaireName;
  final LocalStorage storage;
  final List<String> options;

  const SelectQuestionPage(
      {Key? key,
      required this.progressLine,
      required this.questionnaireName,
      required this.storage,
      required this.options})
      : super(key: key);

  @override
  State createState() {
    return _SelectQuestionPageState();
  }
}

class _SelectQuestionPageState extends State<SelectQuestionPage> {
  late LocalStorage storage;
  late int count;
  late int total;
  List<dynamic> questions = <dynamic>[];
  List<dynamic> responses = <dynamic>[];
  late local_models.QuestionStatus statusObject;
  List<Widget> options = <Widget>[];
  Object? next;
  Object? previous;
  bool finish = false;
  String optionSelected = "";

  @override
  void initState() {
    super.initState();
    storage = widget.storage;
    dynamic questions = jsonDecode(storage.getItem("questions"));
    //print(storage.getItem("object"));
    this.questions = questions;
    dynamic responses = storage.getItem("responses");
    Map m = storage.getItem("object");
    print(m);
    local_models.QuestionStatus statusObject =
        local_models.QuestionStatus.fromJson(m);
    setState(() => this.statusObject = statusObject);
    //Encontrar la siguiente pregunta
    int nextQuestionId = statusObject.current.id + 2;
    int nextQuestionIndex =
        this.questions.indexWhere((element) => element['id'] == nextQuestionId);
    if (nextQuestionIndex != -1) {
      local_models.QuestionStatus newStatusObject =
          local_models.QuestionStatus.fromJson({
        'previous': statusObject.current.toJson(),
        'current': statusObject.next?.toJson(),
        'next': this.questions[nextQuestionIndex]['question']
      });
      storage.setItem("object", newStatusObject);
    } else {
      setState(() => finish = true);
    }
    // Construir el objeto para la siguiente pregunta
    //if (statusObject?.next != null) {
    //newStatusObject['previous'] = statusObject?.current;
    //newStatusObject['current'] = statusObject['next'];
    //newStatusObject['next'] = questions[statusObject['next']['id'] + 1];
    //storage.setItem('object', newStatusObject);
    //}

    //setState(() => this.questions = questions);
    //setState(() => this.responses = responses);
    //setState(() => this.statusObject = statusObject);
  }

  goNext({context, required String option}) {
    double factor = 1 / questions.length;
    double progress = widget.progressLine + factor;
    setState(() => optionSelected = option);
    print(option);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectQuestionPage(
                progressLine: progress,
                questionnaireName: widget.questionnaireName,
                storage: widget.storage,
                options: widget.options)));
  }

  save({context}) {
    double factor = 1 / questions.length;
    double progress = widget.progressLine + factor;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectQuestionPage(
                progressLine: progress,
                questionnaireName: widget.questionnaireName,
                storage: widget.storage,
                options: widget.options)));
  }



  Widget nextButton({required bool finish}) {
    return SizedBox(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ElevatedButton(
              onPressed: () => finish
                  ? save(context: context)
                  : goNext(context: context, option: "ASD"),
              child: Text(finish ? "Finalizar" : "Siguiente")),
        )
      ],
    ));
  }

  Widget columnOptions({required List<String> options, required context}) {
    List<Widget> lst = <Widget>[];
    for (String option in options) {
      lst.add(FractionallySizedBox(
          widthFactor: 0.6,
          child: ElevatedButton(
            onPressed: () => setState(() => optionSelected = option),
            child: Row(
              children: [
                AnimatedOpacity(
                    opacity: optionSelected == option ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: const Icon(Icons.check),
                onEnd: () => goNext(context: context, option: option)),
                Text(option)
              ],
            ),
          )));
      lst.add(const SizedBox(height: 10));
    }
    return Column(children: lst);
  }

/*
  void goToQuestions({context, sections}) async{
    if (storage != null){
        storage.setItem(key, value)
      }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animo App - ${widget.questionnaireName}"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: LinearProgressIndicator(
              value: widget.progressLine,
              semanticsLabel: 'Linear progress indicator',
            ),
          ),
          const SizedBox(height: 30),
          Text(
            statusObject.current.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: columnOptions(options: widget.options, context: context)),
          const SizedBox(height: 20),
          nextButton(finish: finish)
        ],
      ),
    );
  }
}
