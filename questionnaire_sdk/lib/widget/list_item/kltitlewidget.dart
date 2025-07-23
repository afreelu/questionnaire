import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KLTitleWidget extends StatelessWidget {
  @required
  final String? title;
  @required
  final String? description;

  const KLTitleWidget({Key? key, this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(new Center(
      child: Text(
        title ?? "",
        maxLines: 100,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(17),
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 0x48, 0x48, 0x48),
        ),
      ),
    ));
    if (description != null || description != "") {
      widgets.add(new Container(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
        child: Text(
          description ?? "",
          maxLines: 100,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(12),
            fontWeight: FontWeight.w200,
            color: Color.fromARGB(99, 0x48, 0x48, 0x48),
          ),
        ),
      ));
    }
    return Container(
      padding: EdgeInsets.only(
          left: 5.0, right: 5.0, top: 5.0, bottom: ScreenUtil().setHeight(10)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: widgets),
    );
  }
}
