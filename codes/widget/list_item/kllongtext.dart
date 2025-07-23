import 'dart:io';

import 'package:flutter/material.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import '../../utils/dataUtils.dart';
import 'klcomponent.dart';

class KLLongText extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  Size? size;
  @required
  final Function? onTouch; //点击取消红色框

  KLLongText({Key? key, this.map, this.question, this.onTouch})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KLLongTextState();
  }
}

class KLLongTextState extends State<KLLongText> with WidgetsBindingObserver {
  FocusNode? _focusNode;
  // 当前键盘是否是激活状态
  bool isKeyboardActived = false;
  int state = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // 监听输入框焦点变化
    _focusNode?.addListener(_onFocus);
    // 创建一个界面变化的观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 当前是安卓系统并且在焦点聚焦的情况下

      print("页面监听");
      // // 当前是安卓系统并且在焦点聚焦的情况下
      // if (Platform.isAndroid && _focusNode.hasFocus) {
      //   if (isKeyboardActived) {
      //     isKeyboardActived = false;
      //     // 使输入框失去焦点
      //     _focusNode.unfocus();
      //     return;
      //   } else {
      //     print("键盘弹出 false");
      //   }
      //   isKeyboardActived = true;
      // } else {
      //   isKeyboardActived = false;
      //   print("键盘消失");
      //   _focusNode.unfocus();
      // }
    });
  }

  // 既然有监听当然也要有卸载，防止内存泄漏嘛
  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // 焦点变化时触发的函数
  _onFocus() {
    if (_focusNode!.hasFocus) {
      // 聚焦时候的操作
      print("========获取焦点========");
      return;
    }

    print("========失去焦点========");
    // 失去焦点时候的操作
    if (widget.map?[widget.question?.questionId] == "" ||
        widget.map?[widget.question?.questionId] == null) {
      widget.question?.lastAnswerId = 1;
    }
    widget.onTouch!();
    isKeyboardActived = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question == null) {
      return SizedBox();
    }
    if (isKeyboardActived) {
      _focusNode?.unfocus();
    }
    Function? oc = widget.onTouch;
    DataUtils.printMsg("查找Function为null KLLongTextState onTouch: $oc");
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: TextField(
        // keyboardType: TextInputType.multiline,
        // maxLines: null,
        focusNode: _focusNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
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
        // maxLength: 200,
        onChanged: (str) {
          widget.map?[widget.question?.questionId] = str;
        },
        onTap: () {
          widget.onTouch!();
        },
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: (widget.map?[widget.question?.questionId] == null
                ? ""
                : widget.map?[widget.question?.questionId]),
            selection: TextSelection.fromPosition(
              TextPosition(
                  offset: (widget.map?[widget.question?.questionId] == null
                          ? ""
                          : widget.map?[widget.question?.questionId])
                      .length),
            ),
          ),
        ),
      ),
    );
  }
}
