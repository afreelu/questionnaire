import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'package:questionnaire_sdk/widget/list_item/klimagewidget.dart';
import 'klcomponent.dart';

class KLRadio extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  Size? size;
  @required
  void Function()? onTouch;

  // bool isPortrait;
  KLRadio({Key? key, this.map, this.question, this.onTouch}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLRadioState();
  }
}

class KLRadioState extends State<KLRadio> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function? oc = widget.onTouch;

    DataUtils.printMsg("查找Function为null KLRadioState onTouch: $oc \n");

    List<Widget> _list = [];
    // children: _getRadioItem(
    // widget.question!.answer!, _list, widget.question!, widget.map!),
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getRadioItem(
          widget.question?.answer, _list, widget.question, widget.map),
    );
  }

  List<Widget> _getRadioItem(
      List<Answer>? list, List<Widget> _list, Question? question, Map? map) {
    DataUtils.printMsg(
        "RadioItem   list:$list \n _list:$_list  \n question:$question  \n map:$map");

// RadioItem   list:[{anwerId:59358,answerName:Under 18,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// , {anwerId:59360,answerName:19-24 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// , {anwerId:59362,answerName:25-34 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// , {anwerId:59364,answerName:35-44 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// , {anwerId:59366,answerName:45-54 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// , {anwerId:59368,answerName:55 or above,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
// ]
//  _list:[]
//  question:
//  {
//    questionId:10852,
//    questionName:What is your age? (Single choice),
//    index:1,
//    questionType:1,
//    questionLimit:0,
//    hide:0,
//    semaphore:1,
//    answers:[
//      {anwerId:59358,answerName:Under 18,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//      , {anwerId:59360,answerName:19-24 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//      , {anwerId:59362,answerName:25-34 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//      , {anwerId:59364,answerName:35-44 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//      , {anwerId:59366,answerName:45-54 years old,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//      , {anwerId:59368,answerName:55 or above,answerType:1,answerUrl:null,gotoQuestionId:null,mutex:0}
//    ],
//    parentlist:0}

//  map:{}

    for (var i = 0; i < list!.length; i++) {
      Answer answer = list[i];
      _list.add(
        SizedBox(
          height: (i == 0) ? 9.0 : 6.0,
        ),
      );
      DataUtils.printMsg("添加完SizeBox:$_list \n");

      _list.add(
        GestureDetector(
          onTap: () {
            if (map![question?.questionId] == answer.anwerId) return;
            if (map.containsKey(question?.questionId))
              question?.lastAnswerId = map[question.questionId] ?? -1;
            map[question?.questionId] = answer.anwerId;
            widget.onTouch!();
            DataUtils.printMsg("添加完Tap的参数:$map");
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      widget.map?[widget.question?.questionId] == answer.anwerId
                          ? Color.fromARGB(255, 78, 175, 179)
                          : Color.fromARGB(255, 226, 226, 226),
                  width: 1.0),
              color: widget.map?[widget.question?.questionId] == answer.anwerId
                  ? Color.fromARGB(255, 223, 234, 235)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AbsorbPointer(
                  child: Radio(
                    value: answer.anwerId,
                    groupValue: map?[question?.questionId],
                    activeColor: Color.fromARGB(255, 78, 175, 179),
                    onChanged: (b) {},
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        new StringBuffer(((answer.answerNo == null ||
                                        answer.answerNo!.isEmpty)
                                    ? ""
                                    : answer.answerNo! + '.') +
                                answer.answerName!)
                            .toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: widget.map![widget.question!.questionId] ==
                                  answer.anwerId
                              ? Color.fromARGB(255, 72, 72, 72)
                              : Color.fromARGB(255, 112, 112, 112),
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.lerp(
                              FontWeight.w200, FontWeight.w300, 0.5),
                        ),
                      ),
                      KLImageWidget(
                        url: answer.answerUrl ?? "",
                        visible: true,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      DataUtils.printMsg("添加完GestureDetector:$_list \n");
      if (answer.answerType == '3') {
        _list.add(
          Visibility(
            maintainSize: false,
            maintainAnimation: false,
            maintainState: false,
            visible: (widget.map![widget.question!.questionId] != null) &&
                widget.map![widget.question!.questionId] == answer.anwerId,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 78, 175, 179),
                  width: 1.0,
                ),
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(153, 153, 153, 0.35),
                    offset: Offset(2, 2),
                    blurRadius: 4.0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: TextField(
                        minLines: 1,
                        maxLines: 6,
                        // maxLength: 200,
                        style: TextStyle(
                          color: widget.map![widget.question!.questionId] ==
                                  answer.anwerId
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
                          map![new StringBuffer(question!.questionId! +
                                  '_' +
                                  answer.anwerId.toString())
                              .toString()] = str;
                        },
                        onTap: () {
                          widget.onTouch!();
                        },

                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: (widget.map![StringBuffer(
                                            question!.questionId! +
                                                '_' +
                                                answer.anwerId.toString())
                                        .toString()] ==
                                    null
                                ? ""
                                : widget.map![StringBuffer(
                                        question.questionId! +
                                            '_' +
                                            answer.anwerId.toString())
                                    .toString()]),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset: (widget.map![StringBuffer(question
                                                          .questionId! +
                                                      '_' +
                                                      answer.anwerId.toString())
                                                  .toString()] ==
                                              null
                                          ? ""
                                          : widget.map![StringBuffer(
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
      String? type = answer.answerType;
      DataUtils.printMsg("answerType: $type");
      DataUtils.printMsg("添加完Visibility:$_list \n");
    }
    return _list;
  }
}
