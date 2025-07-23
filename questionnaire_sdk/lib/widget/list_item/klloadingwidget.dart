import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';

///访问网络时的加载条（条形）
class KLLoadingPageWidget extends StatelessWidget {
  @required
  final bool? visible;
  @required
  final double? width;
  @required
  final double? height;
  double? value = 0;
  Color? backgroundColor;
  Color? valueColor;

  KLLoadingPageWidget(
      {Key? key,
      this.visible,
      this.width,
      this.height,
      this.value,
      this.backgroundColor,
      this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget linearProgressIndicator;
    if (value! >= 0) {
      linearProgressIndicator = new LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor!),
      );
    } else {
      linearProgressIndicator = new LinearProgressIndicator();
    }
    DataUtils.printMsg("创建loading... $visible");
    if (visible!) {
      return Container(
        child: linearProgressIndicator,
        height: height,
        width: width,
        color: Color.fromARGB(127, 200, 200, 200),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(8),
          right: ScreenUtil().setWidth(8),
          top: ScreenUtil().setHeight(4),
          bottom: ScreenUtil().setHeight(4),
        ),
      );
    }
    return new Container();
  }
}

///访问网络时的加载条（圆形）
class KLLoadingMoreWidget extends StatelessWidget {
  @required
  final bool? visible;
  @required
  final double? width;
  @required
  final double? height;

  const KLLoadingMoreWidget({Key? key, this.visible, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (visible!) {
      return Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: width,
          width: height,
        ),
      );
    }
    return new Container();
  }
}
