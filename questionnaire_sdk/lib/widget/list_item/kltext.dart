import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/bean/vote.dart';

import 'klcomponent.dart';

class KLText extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  Size? size;
  @required
  final Function? onTouch; //点击取消红色框

  KLText({Key? key, this.map, this.question, this.onTouch}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLTextState();
  }
}

class KLTextState extends State<KLText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question == null) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: TextField(
        decoration: InputDecoration(
          // prefixText: widget.question.questionName == null
          //     ? ""
          //     : widget.question.questionName,
          // prefixStyle: TextStyle(
          //   color: Color.fromARGB(255, 61, 61, 61),
          //   fontSize: 14.0,
          //   fontWeight: FontWeight.w400,
          // ),
          labelText: widget.question?.questionName == null
              ? ""
              : widget.question?.questionName,
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 112, 112, 112),
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 226, 226, 226),
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 148, 197, 204),
              width: 1,
            ),
          ),
        ),
        minLines: 1,
        maxLines: 6,
        style: TextStyle(
          color: Color.fromARGB(255, 112, 112, 112),
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, 0.5),
        ),
        onChanged: (str) {
          widget.map![widget.question?.questionId] = str;
        },
        onTap: () {
          widget.onTouch!();
        },
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: (widget.map![widget.question?.questionId] == null
                ? ""
                : widget.map![widget.question?.questionId]),
            selection: TextSelection.fromPosition(
              TextPosition(
                  offset: (widget.map![widget.question?.questionId] == null
                          ? ""
                          : widget.map![widget.question?.questionId])
                      .length),
            ),
          ),
        ),
      ),
    );
  }
}
