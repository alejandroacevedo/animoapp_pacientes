import 'package:flutter/material.dart';
import 'package:animoapp_pacientes/models/questionnaire.dart';
import 'package:animoapp_pacientes/services/questionnaires_services.dart' as ds;
import 'package:animoapp_pacientes/models/local_models_questionnaires.dart'
    as local_models;
import 'package:animoapp_pacientes/views/questions/selection_question.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class QuestionnaireSectionsPage extends StatefulWidget {
  final Questionnaire questionnaire;

  const QuestionnaireSectionsPage({Key? key, required this.questionnaire})
      : super(key: key);

  @override
  State createState() {
    return _QuestionnaireSectionsPageState();
  }
}

class _QuestionnaireSectionsPageState extends State<QuestionnaireSectionsPage> {
  List<Widget> sections = <Widget>[];
  List<Section> sectionsObjects = <Section>[];
  late LocalStorage storage;

  void setSections(value) {
    List<Widget> sList = <Widget>[];
    value.forEach((element) {
      sectionsObjects.add(
          element); // TODO:: mejorar para que sea el listado que devuelve el sevicio y no llenarlo a mano
      sList.add(ListTile(
        leading: ExcludeSemantics(
          child: CircleAvatar(
            child: Text("${element.step}"),
          ),
        ),
        title: Text(element.title),
      ));
    });
    setState(() => sections = sList);
  }

  void prepareStorage(List<Question> questions) {
    setQuestions(questions);
    setStatusObject(questions);
  }

  void setQuestions(List<Question> questions) {
    List<Map> questionsList = <Map>[];
    for (Question q in questions) {
      questionsList.add({'id': q.id, 'question': q.toJson()});
    }
    storage.setItem("questions", jsonEncode(questionsList));
  }

  void setStatusObject(List<Question> questions) {
    Question firstQuestion = questions.first;
    Question nextQuestion = questions[1];
    local_models.QuestionStatus statusObject = local_models.QuestionStatus(
        previous: null, current: firstQuestion, next: nextQuestion);
    storage.setItem("object", statusObject.toJson());
    print(storage.getItem("object"));
  }

  void start() async {
    GenericQuestionnaireValue? generic = await ds.fetchGenericQuestionValue(
        questionnaireId: widget.questionnaire.id);
    if (generic != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectQuestionPage(
                  progressLine: 0.0,
                  questionnaireName: widget.questionnaire.name,
                  storage: storage,
                  options: generic.questionValue)));
    }
  }

  Future<void> localStorageInit() async {
    storage = LocalStorage("questionnaire_${widget.questionnaire.id}.json");
    await storage.clear();
    print("Local storage limpio");
  }

  @override
  void initState() {
    localStorageInit().then((value) => {
          ds
              .fetchQuestions(questionnaireId: widget.questionnaire.id)
              .then((value) => {
                    if (value != null) {prepareStorage(value)}
                  })
        });

    ds.fetchSections(questionnaireId: widget.questionnaire.id).then((value) => {
          if (value != null) {setSections(value)}
        });
    super.initState();
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
        title: Text("Animo App - ${widget.questionnaire.name}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const FractionallySizedBox(
            widthFactor: 0.8,
            child: LinearProgressIndicator(
              value: 0.0,
              semanticsLabel: 'Linear progress indicator',
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Durante este Test veremos: ",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Expanded(
              child: ListView(
            restorationId: '${widget.questionnaire}_sections_list_view',
            padding: const EdgeInsets.all(20),
            children: sections,
          )),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(onPressed: start, child: Text("Empezar")),
              )
            ],
          )),
        ],
      ),
    );
  }
}
