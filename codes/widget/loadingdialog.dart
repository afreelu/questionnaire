import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends Dialog {
  String? text;
  BuildContext? mContext;

  LoadingDialog({Key? key, this.text}) : super(key: key);

  static void dismiss(BuildContext mContext) {
    Navigator.of(mContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 100.0,
          height: 100.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new Text(
                    text ?? "",
                    style: new TextStyle(fontSize: ScreenUtil().setSp(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
