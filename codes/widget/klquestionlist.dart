import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';
import 'package:questionnaire_sdk/utils/questionListUtil.dart';
import 'package:questionnaire_sdk/widget/list_item/kltitlewidget.dart';

import 'list_item/klloadingwidget.dart';
import 'list_item/klquestionwidget.dart';
import 'list_item/klscrollbar.dart';
import 'list_item/klsubmitbutton.dart';

//定义回调函数类型
typedef SubmitCallBack = Function(
    Map map, bool end, int page, Function() callback);
typedef CheckCallBack = Function(
    Map map, List<bool> widgetStates, List<Question> questionList);
typedef BranchCallback = Function(Question question);
typedef PageChangeCallback = Function(int page, Function());

class KLQuestionScrollList extends StatefulWidget {
  @required
  final int? page; //当前显示页
  @required
  final int? max_page;
  @required
  final Map? textMap; //字符显示对应的map
  @required
  final Map? answerMap; //已选择答案对应的map
  //@required final SubmitCallBack onSubmit;//点击提交的回调
  @required
  final CheckCallBack? onCheck; //点击检查题目的回调
  @required
  final BranchCallback? branchCallback; //分支回调
  @required
  final PageChangeCallback? pageChangeCallback; //翻页回调
  @required
  final BaseInfo? baseInfo; //基础信息
  @required
  final String? voteTitle; //标题信息
  @required
  final String? voteDesc; //标题详情
  @required
  final List<Question>? questionList; //问题列表
  @required
  int? showType; //问卷问题的展示类型，0为分页式，1为上拉刷新方式
  @required
  final double? questionTotal; //总题目数，用于显示进度条
  @required
  final double? questionAnswered; //已答题目数，用于显示进度条
  KLQuestionScrollList(
      {Key? key,
      this.textMap,
      this.branchCallback,
      this.answerMap,
      this.pageChangeCallback,
      this.page,
      this.baseInfo,
      this.voteTitle,
      this.questionList,
      this.max_page,
      this.onCheck,
      this.showType,
      this.voteDesc,
      this.questionTotal,
      this.questionAnswered})
      : super(key: key);

  @override
  KLQuestionScrollListState createState() {
    return new KLQuestionScrollListState();
  }
}

class KLQuestionScrollListState extends State<KLQuestionScrollList> {
  ScrollController _controller = new ScrollController();
  List<Question>? questionList;
  Map? map; //记录结果集的map
  final double nomalShadow = 0.0; //错误提示框的阴影长度
  final double errorShadow = 1.0;
  final Color normal = Color.fromARGB(255, 4, 135, 242); //默认背景色
  final Color nomalShadowColor = Colors.transparent; //错误提示框的阴影颜色
  final Color errorShadowColor = Color.fromRGBO(0x99, 0x99, 0x99, 0.35);
  final Color error1 = Colors.red; //错误提示时的字体颜色
  final Color error2 = Color.fromRGBO(78, 175, 179, 0.5); //错误提示框的颜色
  List? list; //基础信息显示的统计list
  List<bool>? widgetStates; //记录是否显示错误提示框的题目
  List<GlobalKey>? globalkeys; //记录为每一个子控件的globalkey，计算控件高度要用
  List<double>? offsetList; //记录每一个控件所在的高度
  double _alignmentY = -1; //记录滚动条的位置
  bool visible = false; //滚动条是否显示的标记
  double scrollHeight = 0; //滚动条的长度，动态算出
  int index = 0; //当前子控件的下标，计算高度时要用
  double tempHeight = 0; //当前已经计算到的高度，计算高度时要用
  bool isChangeBrance = false; //当前是否处于转换分支状态
  bool isChangePage = false; //当前是否处于切换分页状态
  bool loading = false; //当前是否处于加载下一页状态

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  //处理滚动事件，并记录每个控件的高度，错误定位的时候需要使用
  bool _handleScrollNotification(ScrollNotification notification) {
    if (loading) return true;
    final ScrollMetrics metrics = notification.metrics;
    //DataUtils.print('gridview的高度：${globalkeys[0].currentContext.findRenderObject().semanticBounds.height}');
    while (metrics.pixels + context.size!.height > tempHeight &&
        index < questionList!.length + list!.length + 1) {
      //DataUtils.printMsg("当前index==$index,对应length==${questionList.length + list.length},offset的length==${offsetList.length}");
      if (globalkeys![index].currentContext != null) {
        if (index == 0) {
          offsetList![index] = 0;
        } else {
          offsetList![index] =
              tempHeight + globalkeys![index - 1].currentContext!.size!.height;
          //DataUtils.printMsg("offsetList[$index]==${offsetList[index]}");
        }
        //DataUtils.print("组件$index的高度为：${globalkeys[index].currentContext.size.height}");
        tempHeight = offsetList![index];
        index++;
      } else
        break;
    }
    //DataUtils.printMsg("metrics.pixels==${metrics.pixels}------------metrics.maxScrollExtent==${metrics.maxScrollExtent}");
    if (!loading &&
        metrics.pixels == metrics.maxScrollExtent &&
        widget.showType == 2 &&
        widget.page != widget.max_page) {
      setState(() {
        loading = true;
      });
      widget.pageChangeCallback!(widget.page! + 1, () {
        _controller.animateTo(metrics.maxScrollExtent - 1,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
        isChangeBrance = true; //底部发生变化,同分支改变(由于最底部按钮的高度并不记录，故不影响其他)
        loading = false;
      });
    }
    double contextHeight = context.size!.height - ScreenUtil().setHeight(49);
    scrollHeight = contextHeight *
        contextHeight /
        (metrics.maxScrollExtent + contextHeight);
    //print("scrollHeight=$scrollHeight----contextHeight=$contextHeight-----metrics.maxScrollExtent=${metrics.maxScrollExtent}");
    if (metrics.maxScrollExtent > 0)
      setState(() {
        _alignmentY = -1 + (metrics.pixels / metrics.maxScrollExtent) * 2;
        visible = true;
      });
    new Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        visible = false;
      }); //延时操作,滚动条消失
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    map = widget.answerMap;
    questionList = widget.questionList;
    bool vertical = ScreenUtil().screenWidth < ScreenUtil().screenHeight;
    //改变分支时需要还原一些数据结构
    if (isChangeBrance) {
      for (int i = offsetList!.length;
          i <= questionList!.length + list!.length;
          i++) {
        offsetList!.add(0);
      }
      for (int i = globalkeys!.length;
          i <= questionList!.length + list!.length + 2;
          i++) {
        globalkeys!.add(new GlobalKey());
      }
      isChangeBrance = false;
    }
    //换页时需要还原一些数据结构
    if (isChangePage) {
      list = [];
      if (widget.page == 1 && widget.baseInfo != null) {
        if (widget.baseInfo!.sex != null) list!.add("sex");
        if (widget.baseInfo!.age != null) list!.add("age");
        if (widget.baseInfo!.work != null) list!.add("work");
        if (widget.baseInfo!.like != null) list!.add("like");
      }
      offsetList = [];
      for (int i = 0; i <= questionList!.length + list!.length; i++) {
        offsetList!.add(0);
      }
      globalkeys = [];
      for (int i = 0; i <= questionList!.length + list!.length + 2; i++) {
        globalkeys!.add(new GlobalKey());
      }
      isChangePage = false;
    }
    if (list == null) {
      list = [];
      if (widget.page == 1 && widget.baseInfo != null) {
        if (widget.baseInfo!.sex != null) list!.add("sex");
        if (widget.baseInfo!.age != null) list!.add("age");
        if (widget.baseInfo!.work != null) list!.add("work");
        if (widget.baseInfo!.like != null) list!.add("like");
      }
    }
    if (widgetStates == null) widgetStates = [];
    if (offsetList == null) {
      offsetList = [];
      for (int i = 0; i <= questionList!.length + list!.length; i++) {
        offsetList!.add(0);
        //print("offset长度+1,对应length==${offsetList.length}");
      }
    }
    if (globalkeys == null) {
      globalkeys = [];
      for (int i = 0; i <= questionList!.length + list!.length + 2; i++) {
        globalkeys!.add(new GlobalKey());
      }
    }
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    if (ScreenUtil().screenWidth > ScreenUtil().screenHeight) {
      // 横屏
      width -= 200.0;
      if (ScreenUtil().bottomBarHeight > 0) {
        height = height - ScreenUtil().bottomBarHeight * 2.5;
      } else {
        height = height - 100.0;
      }
    } else {
      height -= 200.0;
      width -= 80.0;
    }

    DataUtils.printMsg("执行KLQuestionScrollListState - build函数");
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      //onNotification: null,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverPadding(
                padding: new EdgeInsets.fromLTRB(
                    vertical
                        ? ScreenUtil().setWidth(19)
                        : ScreenUtil().setWidth(38),
                    ScreenUtil().setHeight(16),
                    vertical
                        ? ScreenUtil().setWidth(19)
                        : ScreenUtil().setWidth(38),
                    ScreenUtil().setHeight(33)),
                sliver: new SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == 0) {
                      return KLTitleWidget(
                        key: globalkeys![index],
                        title: widget.voteTitle ?? "",
                        description: widget.voteDesc ?? "",
                      );
                    }
                    if (index == questionList!.length + list!.length + 1) {
                      //print("创建按钮部分$index");
                      if (widget.showType == 1 ||
                          widget.page == widget.max_page)
                        return Center(
                          key: globalkeys![index],
                          child: Padding(
                            padding: new EdgeInsets.fromLTRB(
                                5.0,
                                ScreenUtil().setHeight(14),
                                5.0,
                                ScreenUtil().setHeight(0)),
                            child: KLSubmitButton(
                              textMap: widget.textMap ?? {},
                              page: widget.page ?? 0,
                              max_page: widget.max_page ?? 0,
                              onCheck: () {
                                DataUtils.printMsg("onCheck回调");
                                if (loading) return false;
                                int index = -1;
                                if (widget.onCheck != null) {
                                  setState(() {
                                    widgetStates!.fillRange(
                                        0, widgetStates!.length, true);
                                    index = widget.onCheck!(
                                        map!, widgetStates!, questionList!);
                                    //DataUtils.printMsg("index=$index");
                                  });
                                  if (index != -1)
                                    _controller.animateTo(
                                        offsetList![index + list!.length + 1],
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.ease);
                                  return index == -1;
                                }
                                return false;
                              },
                              pageChangeCallback: (int page) {
                                if (loading) return;
                                setState(() {
                                  loading = true;
                                });
                                widget.pageChangeCallback!(page, () {
                                  widgetStates!
                                      .fillRange(0, widgetStates!.length, true);
                                  if (widget.answerMap!.isEmpty) {
                                    _controller.animateTo(0,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.ease);
                                    isChangePage = true;
                                    for (int i = 0; i < offsetList!.length; i++)
                                      offsetList![i] = 0;
                                    this.index = 0;
                                    tempHeight = 0;
                                    loading = false;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      else
                        return KLLoadingMoreWidget(
                          visible: loading && widget.showType == 2,
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setHeight(20),
                        );
                    }
                    if (widgetStates!.length <= index - list!.length - 1)
                      widgetStates!.add(true);
                    Question question;
                    if (index < list!.length + 1) {
                      question = DataUtils.getBaseInfoQuestion(
                          list!, widget.textMap!, index - 1);
                    } else {
                      question = questionList![index - list!.length - 1];
                      question.index =
                          "${index - list!.length + QuestionListUtil.startIndex}";
                    }
                    Color titleColor = normal;
                    if ((index - list!.length - 1) < 0 ||
                        widgetStates![index - list!.length - 1]) {
                    } else {
                      titleColor = error1;
                    }
                    Color borderColor = normal;
                    if ((index - list!.length - 1) < 0 ||
                        widgetStates![index - list!.length - 1]) {
                      borderColor = normal;
                    } else {
                      borderColor = error2;
                    }
                    return KLQuestionWidget(
                      key: globalkeys![index],
                      question: question,
                      answerMap: map!,
                      branchCallback: (Question question) {
                        isChangeBrance = true;
                        for (int i = index + 2; i < offsetList!.length; i++)
                          offsetList![i] = 0;
                        this.index = index + 1;
                        tempHeight = offsetList![index];
                        //DataUtils.print("执行分支回调");
                        widget.branchCallback!(question);
                      },
                      titleColor: titleColor,
                      borderColor: borderColor,
                      shadow: (index - list!.length - 1) < 0 ||
                              widgetStates![index - list!.length - 1]
                          ? nomalShadow
                          : errorShadow,
                      shadowColor: (index - list!.length - 1) < 0 ||
                              widgetStates![index - list!.length - 1]
                          ? nomalShadowColor
                          : errorShadowColor,
                      callback: () {
                        widgetStates!.fillRange(0, widgetStates!.length, true);
                      },
                    );
                  },
                  childCount: questionList!.length + 2 + list!.length,
                )),
              ),
            ],
          ),
          Container(
            alignment: Alignment(1, _alignmentY),
            padding: EdgeInsets.only(right: 1),
            child: KLScrollBar(
              visible: visible,
              height: scrollHeight,
            ),
          ),
          Positioned(
            child: KLLoadingPageWidget(
              visible: true,
              valueColor: Color.fromARGB(255, 61, 118, 246),
              value: widget.questionAnswered! / widget.questionTotal!,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              width: width,
              height: ScreenUtil().setHeight(11),
            ),
            top: -2,
          ),
        ],
      ),
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.index);
  final int index;
}
