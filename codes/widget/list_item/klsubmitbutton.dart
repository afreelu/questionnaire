import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/language.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';

//定义回调函数类型
typedef SubmitCallBack = Function();
typedef CheckCallBack = Function();
typedef PageChangeCallback = Function(int page);

class KLSubmitButton extends StatelessWidget {
  @required
  final int? page;
  @required
  final int? max_page;
  //@required final SubmitCallBack onSubmit;//点击提交的回调
  @required
  final CheckCallBack? onCheck; //点击回调检查问题
  @required
  final PageChangeCallback? pageChangeCallback; //翻页回调
  @required
  final Map? textMap; //字符显示对应的map

  const KLSubmitButton(
      {Key? key,
      this.page,
      this.max_page,
      this.pageChangeCallback,
      this.textMap,
      this.onCheck})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Function? oc = onCheck;
    Function? aa = pageChangeCallback;
    DataUtils.printMsg(
        "查找Function为null KLSubmitButton onTouch: $oc \n pageChangeCallback:$aa\n");

    String text = page == max_page ? textMap!['submit'] : textMap!['next_page'];
    //print("进入KLSubmitButton Bulid...");
    //print("page=$page,maxPage=$max_page");
    int buttonWidth =
        ScreenUtil().screenWidth > ScreenUtil().screenHeight ? 200 : 330;
    int buttonWidthMin =
        ScreenUtil().screenWidth > ScreenUtil().screenHeight ? 80 : 132;
    int buttonHeight =
        ScreenUtil().screenWidth > ScreenUtil().screenHeight ? 50 : 50;
    if (page != 1 && ScreenUtil().screenWidth > ScreenUtil().screenHeight) {
      buttonWidth = 420;
      buttonWidthMin = 200;
    }
    int fontSize = 16;
    if (ScreenUtil().screenWidth < ScreenUtil().screenHeight &&
        (Language.lang == "pt" || Language.lang == "fr")) {
      fontSize = 12;
    }
    return SizedBox(
      height: ScreenUtil().setHeight(buttonHeight),
      width: ScreenUtil().setWidth(buttonWidth),
      child: Container(
        width: ScreenUtil().setWidth(buttonWidth),
        height: ScreenUtil().setHeight(buttonHeight),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Color.fromARGB(255, 132, 187, 218),
          minWidth: ScreenUtil().setWidth(buttonWidth),
          height: ScreenUtil().setHeight(buttonHeight),
          onPressed: () {
            if (onCheck != null && onCheck!()) pageChangeCallback!(page!);
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
