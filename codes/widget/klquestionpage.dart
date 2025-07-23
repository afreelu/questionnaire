import 'package:flutter/cupertino.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'package:questionnaire_sdk/utils/questionListUtil.dart';

import 'klquestionlist.dart';

//定义回调函数类型
typedef SubmitCallBack = Function(
    Map map, bool end, int page, Function() callback);
typedef RequestCallBack = Function(int page, Function() callback);
typedef CheckCallBack = Function(
    Map map, List<bool> widgetStates, List<Question> questionList);
typedef BranchCallback = Function(Question question);

//TODO 历史版本遗留的分页层，待优化
class KLQuestionPage extends StatefulWidget {
  @required
  final Map? textMap; //字符显示对应的map
  @required
  final Vote? vote; //从服务器获取到的vote对象
  @required
  final Map? answerMap; //已选择答案对应的map
  @required
  final SubmitCallBack? onSubmit; //点击提交的回调
  @required
  final RequestCallBack? onRequest; //点击请求的回调
  @required
  final CheckCallBack? onCheck; //点击检查的回调
  @required
  final Map<String, bool>? brances; //当前加载的分支
  @required
  final BranchCallback? branchCallback; //分支回调

  KLQuestionPage(
      {Key? key,
      this.textMap,
      this.vote,
      this.answerMap,
      this.onSubmit,
      this.brances,
      this.branchCallback,
      this.onCheck,
      this.onRequest})
      : super(key: key); //分支回调

  @override
  State<StatefulWidget> createState() {
    return new KLQuestionPageState();
  }
}

class KLQuestionPageState extends State<KLQuestionPage> {
  List<Question>? questionList;

  KLQuestionPageState() {}

  @override
  Widget build(BuildContext context) {
    String? desc = "";
    if (widget.vote!.page == 1) {
      desc = widget.vote!.voteDesc;
    } else {
      desc = "";
    }
    Function? oc = widget.onCheck;
    DataUtils.printMsg("查找Function为null KLQuestionPageState onCheck:$oc");

    //DataUtils.printQuestionList(questionListPages[page]);
    return KLQuestionScrollList(
      onCheck: widget.onCheck,
      page: widget.vote?.page ?? 0,
      max_page: widget.vote?.pageTotal ?? 0,
      textMap: widget.textMap,
      answerMap: widget.answerMap,
      branchCallback: widget.branchCallback,
      voteTitle: widget.vote?.voteTitle ?? "",
      voteDesc: desc!,
      questionTotal: QuestionListUtil.totalWeight,
      questionAnswered: QuestionListUtil.currentWeight,
      questionList: QuestionListUtil.showingList!,
      baseInfo: widget.vote?.baseInfo!,
      showType: widget.vote?.pageStyle!,
      pageChangeCallback: (int page, Function() callback) {
        setState(() {
          if (widget.vote?.pageStyle == 1 ||
              widget.vote?.page == widget.vote?.pageTotal)
            widget.onSubmit!(widget.answerMap!, page == widget.vote?.pageTotal,
                page, callback);
          else
            widget.onRequest!(page, callback);
        });
      },
    );
  }
}
