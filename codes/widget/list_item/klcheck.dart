import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'package:questionnaire_sdk/widget/list_item/klimagewidget.dart';
import 'klcomponent.dart';

class KLCheck extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  Size? size;
  int? answerNumber;
  @required
  Function()? onTouch;

  // bool isPortrait;

  KLCheck({Key? key, this.map, this.question, this.onTouch, this.answerNumber})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLCheckState();
  }
}

class KLCheckState extends State<KLCheck> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question == null) {
      return SizedBox();
    }

    // // widget.isPortrait =
    //     MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;

    List<Widget> _list = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getCheckItem(
          widget.question!.answer!, _list, widget.question!, widget.map!)!,
    );
  }

  List<Widget>? _getCheckItem(
      List<Answer> list, List<Widget> _list, Question question, Map map) {
    if (!(widget.map?.keys.contains(widget.question?.questionId))!) {
      widget.map?[widget.question?.questionId] = [];
    }
    for (var i = 0; i < list.length; i++) {
      Answer answer = list[i];

      _list.add(
        SizedBox(
          height: (i == 0) ? 9.0 : 6.0,
        ),
      );
      Function? oc = widget.onTouch;
      DataUtils.printMsg("查找Function为null _getCheckItem onTouch: $oc");
      _list.add(
        AbsorbPointer(
          absorbing: !answer.clickable,
          child: GestureDetector(
            onTap: () {
              // DataUtils.printMsg("GestureDetector onTap");
              if (widget.map?[widget.question?.questionId]
                  .contains(answer.anwerId)) {
                question.checkedId = answer.anwerId!;
                widget.map?[widget.question?.questionId].remove(answer.anwerId);
                widget.onTouch!();
                return;
              }
              if (widget.answerNumber == 0 ||
                  widget.map?[widget.question?.questionId].length <
                      widget.answerNumber) {
                widget.map![widget.question?.questionId].add(answer.anwerId);
                DataUtils.clearMutexAnswer(widget.map!, question, answer.mutex);
                question.checkedId = answer.anwerId!;
                widget.onTouch!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.map?[widget.question?.questionId]
                            .contains(answer.anwerId)
                        ? Color.fromARGB(255, 78, 175, 179)
                        : Color.fromARGB(255, 226, 226, 226),
                    width: 1.0),
                color: widget.map?[widget.question?.questionId]
                        .contains(answer.anwerId)
                    ? Color.fromARGB(255, 223, 234, 235)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AbsorbPointer(
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: Color.fromARGB(255, 78, 175, 179),
                      value: widget.map?[widget.question?.questionId]
                          .contains(answer.anwerId),
                      onChanged: (b) {},
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringBuffer(((answer.answerNo == null ||
                                          answer.answerNo!.isEmpty)
                                      ? ""
                                      : answer.answerNo! + '.') +
                                  answer.answerName!)
                              .toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: widget.map?[widget.question?.questionId]
                                    .contains(answer.anwerId)
                                ? Color.fromARGB(255, 72, 72, 72)
                                : Color.fromARGB(255, 112, 112, 112),
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.lerp(
                                FontWeight.w200, FontWeight.w300, 0.5),
                          ),
                        ),
                        KLImageWidget(
                          url: answer.answerUrl,
                          visible: true,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (answer.answerType == '3') {
        _list.add(
          Visibility(
            maintainSize: false,
            maintainAnimation: false,
            maintainState: false,
            visible: widget.map?[widget.question?.questionId]
                .contains(answer.anwerId),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 78, 175, 179),
                  width: 1.0,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        color: Color.fromARGB(255, 242, 242, 242),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.35),
                            offset: Offset(2, 2),
                            blurRadius: 4.0,
                          )
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: TextField(
                        minLines: 1,
                        maxLines: 6,
                        // maxLength: 200,
                        style: TextStyle(
                          color: widget.map?[widget.question?.questionId]
                                  .contains(answer.anwerId)
                              ? Color.fromARGB(255, 72, 72, 72)
                              : Color.fromARGB(255, 112, 112, 112),
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.lerp(
                              FontWeight.w200, FontWeight.w300, 0.5),
                        ),
                        decoration: InputDecoration(
                          // border: UnderlineInputBorder(
                          //   borderSide: BorderSide(
                          //     width: 2.0,
                          //     color: Colors.black,
                          //   ),
                          // ),
                          border: InputBorder.none,
                        ),

                        onChanged: (str) {
                          map[StringBuffer(question.questionId! +
                                  '_' +
                                  answer.anwerId.toString())
                              .toString()] = str;
                        },
                        onTap: () {
                          widget.onTouch!();
                        },
                        // controller: new TextEditingController(
                        //   text: map[new StringBuffer(question.questionId +
                        //           '_' +
                        //           answer.anwerId.toString())
                        //       .toString()],
                        // ),

                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: (widget.map?[StringBuffer(
                                            question.questionId! +
                                                '_' +
                                                answer.anwerId.toString())
                                        .toString()] ==
                                    null
                                ? ""
                                : widget.map?[StringBuffer(
                                        question.questionId! +
                                            '_' +
                                            answer.anwerId.toString())
                                    .toString()]),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset: (widget.map?[StringBuffer(question
                                                          .questionId! +
                                                      '_' +
                                                      answer.anwerId.toString())
                                                  .toString()] ==
                                              null
                                          ? ""
                                          : widget.map?[StringBuffer(
                                                  question.questionId! +
                                                      '_' +
                                                      answer.anwerId.toString())
                                              .toString()])
                                      .length),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return _list;
  }
}
