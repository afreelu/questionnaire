import 'package:flutter/material.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'klcomponent.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KLSelect extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  Size? size;
  @required
  Function()? onTouch;

  KLSelect({Key? key, this.map, this.question, this.onTouch}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLSelectState();
  }
}

class KLSelectState extends State<KLSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function? oc = widget.onTouch;
    DataUtils.printMsg("查找Function为null KLSelectState onTouch: $oc \n");

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 226, 226, 226),
            width: 1.0,
          ),
        ),
        color: Color.fromARGB(255, 242, 242, 242),

        // boxShadow: [
        //   BoxShadow(
        //     color: Color.fromRGBO(153, 153, 153, 0.35),
        //     offset: Offset(2, 2),
        //     blurRadius: 4.0,
        //   )
        // ],
      ),
      height: ScreenUtil().setWidth(50),
      width: ScreenUtil().setWidth(300),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: _getMenuItem(widget.question?.answer),
          hint: Text(
            widget.question?.questionName ?? "",
            style: TextStyle(
              color: Color.fromARGB(255, 112, 112, 112),
              fontSize: ScreenUtil().setSp(14),
              fontWeight:
                  FontWeight.lerp(FontWeight.w200, FontWeight.w300, 0.5),
            ),
          ),
          onChanged: (value) {
            widget.map?[widget.question?.questionId] = value;
            widget.onTouch!();
          },
          isExpanded: true,
          value: widget.map?[widget.question?.questionId],
          isDense: false,
        ),
      ),
    );
  }

  List<DropdownMenuItem> _getMenuItem(list) {
    List<DropdownMenuItem> _list = [];
    for (Answer answer in list) {
      _list.add(
        DropdownMenuItem(
          child: Text(
            answer.answerName ?? "",
            style: TextStyle(
              color: Color.fromARGB(255, 112, 112, 112),
              fontSize: ScreenUtil().setSp(14),
              fontWeight:
                  FontWeight.lerp(FontWeight.w200, FontWeight.w300, 0.5),
            ),
          ),
          value: answer.anwerId,
        ),
      );
    }
    return _list;
  }
}
