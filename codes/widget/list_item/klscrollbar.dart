import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';

///滚动条
class KLScrollBar extends StatelessWidget {
  final bool? visible;
  final double? height;
  const KLScrollBar({Key? key, this.visible, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DataUtils.printMsg("创建滚动条 $visible ---- $height");
    if (visible! && height != null)
      return Container(
        width: 8,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[350]),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Icon(
        //       Icons.arrow_drop_up,
        //       size: 8,
        //     ),
        //     Icon(
        //       Icons.arrow_drop_down,
        //       size: 8,
        //     ),
        //   ],
        // ),
      );
    else
      return Container(
        width: 0,
        height: 0,
      );
  }
}
