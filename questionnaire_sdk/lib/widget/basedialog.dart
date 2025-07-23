import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';

class BaseDialog extends StatefulWidget {
  final String? title;
  final bool? cancelAble;
  Function()? dismissCallback; // 弹窗关闭回调
  final Function()? cancelCallback; //取消按钮
  final Widget? body;
  final double? width, height;
  final Alignment? alignment;

  BaseDialog(
      {this.title = "",
      this.body,
      this.width,
      this.height,
      this.cancelAble = true,
      this.dismissCallback,
      this.cancelCallback,
      this.alignment});

  @override
  _BaseDialogState createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog> {
  _BaseDialogState();

  @override
  Widget build(BuildContext context) {
    Function? dismiss = widget.dismissCallback;
    Function? cancel = widget.cancelCallback;
    DataUtils.printMsg("创建问卷页面 $dismiss \n  cancel:$cancel");
    double titlePadding = 50.0;
    // 构建弹框内容
    Container _dialogContent = Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 242, 242, 242),
          borderRadius: BorderRadius.circular(8.0), //8像素圆角
          boxShadow: [
            //阴影
            BoxShadow(
                color: Color.fromRGBO(153, 153, 153, 0.35),
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0)
          ]),
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: widget.width,
            height: 50.0,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: titlePadding,
                    right: titlePadding,
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 64, 158, 255),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                      ), //圆角
                      boxShadow: [
                        //阴影
                        BoxShadow(
                            color: Color.fromRGBO(153, 153, 153, 0.35),
                            offset: Offset(2.0, 2.0),
                            blurRadius: 1.0)
                      ]),
                  child: Center(
                    child: Text(
                      widget.title ?? "问卷调查",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromARGB(255, 242, 242, 242),
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: _clickCancel,
                        minWidth: 0,
                        child: Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 215, 215, 215),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 内容

          Positioned(
            top: 52.0,
            child: SizedBox(
              width: widget.width,
              height: widget.height! - 52.0,
              child: widget.body,
            ),
          ),
        ],
      ),
    );

    DataUtils.printMsg("创建问卷页面Container完成");

    // 构建弹框布局
    return PopScope(
      child: GestureDetector(
        onTap: () {
          DataUtils.printMsg("PopScope-onTap");
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          // widget.cancelAble! ? _dismissDialog() : null;
        },
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: widget.alignment!,
            child: SizedBox(
              // 设置弹框宽度
              width: widget.width,
              height: widget.height,
              child: _dialogContent,
            ),
          ),
        ),
      ),
      canPop: widget.cancelAble!,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        DataUtils.printMsg(
            "PopScope-onPopInvoked" + widget.cancelAble!.toString());
        widget.cancelAble!;
      },
    );

    /*
    // 构建弹框布局
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            widget.cancelAble! ? _dismissDialog() : null;
          },
          child: Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: widget.alignment!,
              child: SizedBox(
                // 设置弹框宽度
                width: widget.width,
                height: widget.height,
                child: _dialogContent,
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return widget.cancelAble!;
        });
  */
  }

  /// 点击隐藏dialog
  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback!();
    }
    Navigator.of(context).pop();
  }

  /// 点击取消
  void _clickCancel() {
    if (widget.cancelCallback != null) {
      widget.cancelCallback!();
    }
    _dismissDialog();
  }
}
