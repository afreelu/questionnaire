import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'klcomponent.dart';

class klStartGradeWidget extends StatefulWidget implements KLComponent {
  final Map? map;
  final Question? question;
  @required
  Function()? onTouch;

  klStartGradeWidget({Key? key, this.map, this.question, this.onTouch})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => klStartGradeState();
}

class klStartGradeState extends State<klStartGradeWidget> {
  double rateNum = 0;
  @override
  Widget build(BuildContext context) {
    Function? oc = widget.onTouch;
    DataUtils.printMsg("查找Function为null klStartGradeState onTouch: $oc \n");

    String anwerId = widget.map?[widget.question?.questionId];
    if (anwerId == widget.question?.answer?[0].anwerId.toString()) {
      rateNum = 1;
    } else if (anwerId == widget.question?.answer?[1].anwerId.toString()) {
      rateNum = 2;
    } else if (anwerId == widget.question?.answer?[2].anwerId.toString()) {
      rateNum = 3;
    } else if (anwerId == widget.question?.answer?[3].anwerId.toString()) {
      rateNum = 4;
    } else if (anwerId == widget.question?.answer?[4].anwerId.toString()) {
      rateNum = 5;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RatingBar.builder(
        initialRating: rateNum,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star_rounded,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          int answerId = widget.question!.answer![0].anwerId!;
          if (rating == 1) {
            answerId = widget.question!.answer![0].anwerId!;
          } else if (rating == 2) {
            answerId = widget.question!.answer![1].anwerId!;
          } else if (rating == 3) {
            answerId = widget.question!.answer![2].anwerId!;
          } else if (rating == 4) {
            answerId = widget.question!.answer![3].anwerId!;
          } else if (rating == 5) {
            answerId = widget.question!.answer![4].anwerId!;
          } else {
            answerId = widget.question!.answer![0].anwerId!;
          }
          widget.map?.remove(widget.question?.questionId);
          widget.map?[widget.question?.questionId] = answerId.toString();
          widget.onTouch!();
          print("星星数：$rating");
        },
      ),
    ]);
  }
}
