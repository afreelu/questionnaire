import 'package:flutter/cupertino.dart';

///加载图片
class KLImageWidget extends StatelessWidget {
  @required
  final String? url;
  @required
  final bool? visible;

  const KLImageWidget({Key? key, this.url, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || "" == url || !visible!) return Container();
    return Container(
      padding: const EdgeInsets.only(top: 5.0, right: 10.0, bottom: 10.0),
      child: Image.network(
        url!,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
