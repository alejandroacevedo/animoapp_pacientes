import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:animoapp_pacientes/models/questionnaire.dart' as qs;
import 'package:animoapp_pacientes/views/questionnaires/questionnaire_section.dart';

class QuestionnaireResume extends StatelessWidget {
  const QuestionnaireResume({Key? key, required this.q}) : super(key: key);
  final qs.Questionnaire q;

  goToSections({context}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnaireSectionsPage(questionnaire: q)));
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.quiz_outlined,
                          color: Colors.green,
                        ),
                        Expanded(
                            child: Text(
                          q.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.orange),
                        )),

                        Text(
                          "*${q.totalTime}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.blueAccent),
                        ),
                        const Icon(Icons.access_time_outlined, size: 16),
                      ],
                    )),
                collapsed: Text(
                  q.shortDescription,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(q.objective),
                    ElevatedButton(onPressed: () => goToSections(context: context), child: Text("Responder"))
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
