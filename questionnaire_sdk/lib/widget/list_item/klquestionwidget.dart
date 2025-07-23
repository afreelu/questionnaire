import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'package:questionnaire_sdk/widget/list_item/klStartgradeWidget.dart';

import 'klcheck.dart';
import 'kldropdown.dart';
import 'kllongtext.dart';
import 'klradio.dart';
import 'klselect.dart';
import 'kltext.dart';

///展示问卷题目的基类
class KLQuestionWidget extends StatefulWidget {
  @required
  final Question question;
  @required
  final Map answerMap;
  @required
  Color? titleColor;
  @required
  Color? borderColor;
  @required
  Color shadowColor;
  @required
  double shadow;
  @required
  final Function() callback; //取消红色提示框的回调
  @required
  final Function(Question question) branchCallback; //分支回调

  KLQuestionWidget(
      {required Key key,
      required this.question,
      required this.answerMap,
      this.titleColor,
      this.borderColor,
      required this.shadowColor,
      required this.shadow,
      required this.callback,
      required this.branchCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLQuestionWidgetState();
  }
}

class KLQuestionWidgetState extends State<KLQuestionWidget> {
  void Function()? onTouch;

  @override
  void initState() {
    super.initState();
    onTouch = () {
      setState(() {
        print("执行了onTouch");
        widget.titleColor = Color.fromARGB(255, 72, 72, 72);
        widget.borderColor = Colors.transparent;
        widget.shadow = 0.0;
        widget.shadowColor = Colors.transparent;
        if (widget.callback != null) widget.callback();
        if (widget.branchCallback != null) {
          widget.branchCallback(widget.question);
          print("执行了branchCallback");
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question == null) {
      return SizedBox();
    }
    Function? oc = widget.callback;
    Function? bc = widget.branchCallback;
    DataUtils.printMsg(
        "查找Function为null KLQuestionWidgetState onTouch: $oc \n branchCall:$bc");
    Widget _title = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: StringBuffer(((widget.question.index == null ||
                            widget.question.index!.isEmpty ||
                            widget.question.index == "")
                        ? ""
                        : widget.question.index! + '.') +
                    widget.question.questionName!)
                .toString(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17),
              fontWeight: FontWeight.w400,
              color: widget.titleColor == null
                  ? Color.fromARGB(255, 72, 72, 72)
                  : widget.titleColor,
            ),
          ),
          TextSpan(
            text: widget.question.required ? "*" : "",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17),
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
    Widget? _content;
    if (widget.question.questionType == "1") {
      DataUtils.printMsg("问卷类型1 onTouch:$onTouch");
      _content = KLRadio(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "2") {
      DataUtils.printMsg("问卷类型2");
      _content = KLCheck(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
        answerNumber: int.parse(widget.question.questionLimit!),
      );
    } else if (widget.question.questionType == "3") {
      DataUtils.printMsg("问卷类型3");
      _content = KLLongText(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "4") {
      DataUtils.printMsg("问卷类型4");
      _title = Container();
      _content = KLSelect(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "5") {
      DataUtils.printMsg("问卷类型5");
      _title = Container();
      _content = KLText(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "11") {
      DataUtils.printMsg("问卷类型11");
      _content = klDropdownWidget(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "12") {
      DataUtils.printMsg("问卷类型12");
      _content = klStartGradeWidget(
        map: widget.answerMap,
        question: widget.question,
        onTouch: onTouch,
      );
    } else if (widget.question.questionType == "6") return Container();

    DataUtils.printMsg("问卷类型判断完毕" + widget.question.questionType!);

    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, ScreenUtil().setHeight(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(
          width: 1.5,
          color: widget.borderColor ?? Colors.transparent,
        ),
        color: Color.fromARGB(255, 242, 242, 242),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor == null
                ? Colors.transparent
                : widget.shadowColor,
            offset: Offset(widget.shadow, widget.shadow),
            // blurRadius: 1.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title,
          SizedBox(
            height: 9.0,
          ),
          _content!,
        ],
      ),
    );
  }
}
