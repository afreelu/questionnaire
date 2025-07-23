import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire_sdk/language.dart';
import 'package:questionnaire_sdk/questionnairplugin.dart';
import 'package:questionnaire_sdk/utils/httpUtils.dart';
import 'package:questionnaire_sdk/utils/questionListUtil.dart';
import 'package:questionnaire_sdk/widget/klquestionpage.dart';
import 'bean/response.dart';
import 'bean/vote.dart';
import 'utils/dataUtils.dart';
import 'widget/basedialog.dart';
import 'widget/loadingdialog.dart';

typedef VoteCallBack = Function(int retCode, String retMsg);

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
      unselectedWidgetColor: Color.fromARGB(255, 204, 204, 204),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final String VERSION = "1.3.6_cn";
  final String VERSION =
      "3.19.6_cn"; // 苹果审核需要flutter 相关的SDK 做隐私信息的披露，升级flutter到最新版本 2024-05-10

  Vote? vote;
  Map? textMap;
  final Map answerMap = new Map();
  Map<String, bool> brances = new Map<String, bool>();
  bool visible = false;
  bool vertical = true;
  int submitPage = 0;
  @override
  void initState() {
    super.initState();
    print("Questionnair sdk version:$VERSION");
    WidgetsBinding.instance.addObserver(this);
    //判断软键盘是否显示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //首次进入问卷系统要从服务器拉取问卷内容
      if (textMap == null || vote == null) init();
      setState(() {
        DataUtils.printMsg("initState -- init 后");
        if (MediaQuery.of(context).viewInsets.bottom > 0)
          visible = true;
        else
          visible = false;

        DataUtils.printMsg("initState -- init 后 $visible");
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DataUtils.printMsg("didChangeMetrics");
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom > 0)
          visible = true;
        else
          visible = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //隐藏顶部状态栏和底部操作栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    ScreenUtil.init(context, designSize: Size(380, 830), splitScreenMode: true);
    DataUtils.printMsg("屏幕的大小：" +
        ScreenUtil().screenWidth.toString() +
        "===" +
        ScreenUtil().screenHeight.toString() +
        "方向：" +
        ScreenUtil().orientation.toString());

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

      Size view_size = Size(width, height);
      ScreenUtil.init(context, designSize: view_size, splitScreenMode: true);
      vertical = false;
    } else {
      height -= 200.0;
      width -= 80.0;
      Size view_size = Size(width, height);
      ScreenUtil.init(context, designSize: view_size, splitScreenMode: true);
      vertical = true;
    }

    //int height = ScreenUtil.screenWidth>ScreenUtil.screenHeight?750:821;
    //DataUtils.print("执行弹窗build");
    if (vote == null) {
      DataUtils.printMsg("vote还没有内容，显示加载中:$textMap");
      return LoadingDialog(
        text: (textMap != null && textMap!['loading'] != null)
            ? textMap!['loading']
            : "loading...",
      );
    } else {
      DataUtils.printMsg("vote有内容了:$vote \n显示加载中:$textMap");
      return BaseDialog(
        alignment: visible ? Alignment.bottomCenter : Alignment.center,
        title: textMap?['survey'],
        width: width,
        height: height,
        dismissCallback: () {
          DataUtils.printMsg("dismissCallback点击关闭问卷页面");
          QuestionnairPlugin.finishWithCallback(-1, "");
        },
        cancelCallback: () {
          DataUtils.printMsg("cancelCallback点击关闭问卷页面");
          QuestionnairPlugin.finishWithCallback(-1, "");
        },
        cancelAble: true,
        body: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: KLQuestionPage(
            textMap: textMap!,
            answerMap: answerMap,
            vote: vote!,
            brances: brances,
            branchCallback: (Question question) {
              setState(() {
                print("执行改变分支---start");
                // DataUtils.removeBrance(brances,question,answerMap,vote);
                // DataUtils.addBrance(brances,question,answerMap);
                // DataUtils.printMsg("brances:$answerMap");
                QuestionListUtil.changeQuestionList(question, answerMap);
                vote!.question = QuestionListUtil.showingList;
                print("执行改变分支---end");
              });
            },
            onSubmit: (Map map, bool end, int page, Function() callback) {
              DataUtils.printMsg("result:$map");
              Map<String, String> result = new Map();
              String baseInfoJson =
                  DataUtils.getBaseInfoFromMap(map, vote!.baseInfo!);
              DataUtils.printMsg("baseInfoJson:$baseInfoJson");
              result["base_info"] = baseInfoJson;
              String voteResultJson = DataUtils.getVoteResultFromMap(
                  map, QuestionListUtil.showingList);
              DataUtils.printMsg("voteResultJson:$voteResultJson");
              result["vote_result"] = voteResultJson;
              submit(result, end, page, callback);
            },
            onRequest: (int page, Function() callback) {
              getVoteByRequest(page, (retCode, retMsg) {
                if (retCode == 0) {
                  Vote vote =
                      DataUtils.getVoteFromJson(retMsg, this.vote!, false);
                  setState(() {
                    this.vote = vote;
                    callback();
                  });
                } else {
                  if (retCode < 0) retMsg = textMap?['network_error'];
                  DataUtils.printMsg("请求下一页$page 返回状态码:" +
                      retCode.toString() +
                      "返回的内容:" +
                      retMsg);
                  QuestionnairPlugin.showToast(retMsg);
                  setState(() {
                    callback();
                  });
                }
              });
            },
            onCheck: (Map map, List<bool> widgetStates,
                List<Question> questionList) {
              DataUtils.printMsg("result:$map");
              int index =
                  DataUtils.checkResult(map, vote!, widgetStates, questionList);
              if (index != -1) QuestionnairPlugin.showToast(textMap?['noFill']);
              return index;
            },
          ),
        ),
      );
    }
  }

  Future<void> submit(Map<String, String> request, bool end, int page,
      Function() callback) async {
    final String url = await QuestionnairPlugin.getSubmitUrl();
    String submitUrl = url + "&page=$page&version=2";
    DataUtils.printMsg("getSubmitUrl: \n$submitUrl");
    new HttpUtils().httpPost(submitUrl, request,
        // ignore: missing_return
        (int code, String msg) {
      if (code == 0) {
        DataUtils.printMsg("submit finished.\n$msg");
        Response response = DataUtils.getResponseFromJSON(msg);
        if (!end) {
          if (response.retcode == 0) {
            Vote vote = DataUtils.getVoteFromJson(response.data!, null, true);
            setState(() {
              this.vote = vote;
              answerMap.clear();
              brances.clear();
              callback();
            });
          } else {
            QuestionnairPlugin.showToast(response.retmsg!);
            setState(() {
              callback();
            });
          }
        } else
          QuestionnairPlugin.finishWithCallback(
              response.retcode!, response.retmsg!);
      } else {
        QuestionnairPlugin.showToast(textMap?['network_error']);
        DataUtils.printMsg("Post请求结束:" + code.toString() + msg);
        setState(() {
          callback();
        });
      }
      return callback();
    });
  }

  Future<void> init() async {
    DataUtils.setDebug(await QuestionnairPlugin.isDebug());
    if (textMap == null) {
      final Map? map = Language.getText(await QuestionnairPlugin.getText());
      DataUtils.printMsg("getTextMap:$map");
      setState(() {
        textMap = map;
      });
    }
    if (vote == null) {
      getVoteByRequest(1, (retCode, retMsg) {
        if (retCode == 0) {
          Vote vote = DataUtils.getVoteFromJson(retMsg, null, true);
          setState(() {
            this.vote = vote;
          });
        } else {
          if (retCode < 0) retMsg = textMap?['network_error'];
          DataUtils.printMsg(
              "付值Vote有内容了但是还是结束了thisVote:" + this.vote.toString());
          QuestionnairPlugin.finishWithCallback(retCode, retMsg);
        }
      });
    }
  }

  Future<void> getVoteByRequest(int page, VoteCallBack callBack) async {
    final String url = await QuestionnairPlugin.getRequestUrl();
    if (vote != null && submitPage == page) callBack(0, '');
    submitPage = page;
    String requestUrl = url + '&page=$page&version=2';
    DataUtils.printMsg("getRequestUrl:$requestUrl");
    new HttpUtils().httpGet(requestUrl,
        // ignore: missing_return
        (int code, String retmsg) {
      if (code == 0) {
        DataUtils.printMsg("get request data.\n$retmsg");
        Response response = DataUtils.getResponseFromJSON(retmsg);
        if (response.retcode == 0) {
          return callBack(response.retcode!, response.data!);
        } else {
          return callBack(response.retcode!, response.retmsg!);
        }
      } else {
        return callBack(code, retmsg);
      }
    });
  }
}
