import 'package:flutter/material.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import '../../questionnairplugin.dart';
import 'klcomponent.dart';
import 'package:questionnaire_sdk/language.dart';

class klDropdownWidget extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  @required
  Function()? onTouch;

  klDropdownWidget({Key? key, this.map, this.question, this.onTouch})
      : super(key: key);

  @override
  klDropdownState createState() => klDropdownState();
}

class klDropdownState extends State<klDropdownWidget> {
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    Function? oc = widget.onTouch;
    DataUtils.printMsg("查找Function为null klDropdownWidget onTouch: $oc");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.only(top: 3, bottom: 3, left: 15),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromARGB(255, 226, 226, 226), width: 1),
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(4, 4),
                  bottom: Radius.elliptical(4, 4))),
          child: DropdownButton(
            hint: Text(Language.language?.languageMap['dropdown_notice']),
            value: dropdownValue,
            isExpanded: true,
            elevation: 1,
            underline: Container(color: Colors.black87),
            // icon: Icon(Icons.arrow_drop_down),
            // iconSize: 30,
            items: widget.question?.answer?.map((Answer value) {
              return DropdownMenuItem<String>(
                value: value.answerName,
                child: new Text(
                  value.answerName ?? "",
                  style: TextStyle(
                      color: dropdownValue == value.answerName
                          ? Colors.black87
                          : Colors.grey),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
                for (Answer answer in widget.question!.answer!) {
                  if (answer.answerName!.contains(newValue!)) {
                    if (widget.map?[widget.question?.questionId] ==
                        answer.anwerId) return;
                    if (widget.map!.containsKey(widget.question?.questionId))
                      widget.question?.lastAnswerId =
                          widget.map![widget.question?.questionId];
                    widget.map!.remove(widget.question?.questionId);
                    widget.map![widget.question?.questionId] = answer.anwerId;
                    print(answer.answerName);
                    print(widget.map![widget.question?.questionId]);
                  }
                }
                widget.onTouch!();
              });
            },
          ),
        ),
      ],
    );
  }
}
