import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:animoapp_pacientes/services/questionnaires_services.dart' as ds;
import 'package:animoapp_pacientes/widgets/questionnaire_container.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  List<QuestionnaireResume> questionnaires = <QuestionnaireResume>[];

  void setList(value){
    List<QuestionnaireResume> qList = <QuestionnaireResume>[];
    value.forEach((element) {
      qList.add(QuestionnaireResume(q: element));
    });
    setState(() => questionnaires = qList);
  }

  @override
  void initState() {
    // TODO: implement initState

    ds.fetchQuestionnaires().then((value) => {
      if (value != null){
        setList(value)
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animo App - Questionarios"),
      ),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: questionnaires,
        ),
      ),
    );
  }
}