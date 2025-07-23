import 'dart:convert';
import 'package:questionnaire_sdk/bean/baseinforesult.dart';
import 'package:questionnaire_sdk/bean/questionresult.dart' as result;
import 'package:questionnaire_sdk/bean/response.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/questionListUtil.dart';

class DataUtils {
  static bool debug = false;

  ///将json字符串转换为Vote实体
  static Vote getVoteFromJson(String jsonStr, Vote? v, bool page) {
    DataUtils.printMsg("VoteJson实体:$jsonStr \n" + "\n" + "page:$page");
    Map<String, dynamic> map = json.decode(jsonStr);
    DataUtils.printMsg("\n map实体:$map");
    //将服务器数据转换为我们要用的数据结构(分支编号)
    Vote? vv;

    if (page) {
      vv = Vote.fromJson(map);
      DataUtils.printMsg("\n v实体:" +
          vv.voteId.toString() +
          "questionMap:" +
          vv.questionMap.toString() +
          "\n" +
          "mainQuestions:" +
          vv.mainQuestions.toString());
      QuestionListUtil.createQuestionList(vv.question, vv.currentShowedQuestion,
          vv.currentAnswered, vv.questionMap, vv.mainQuestions);
    } else {
      Vote vote = Vote.fromJson(map);
      if (v?.page != vote.page) {
        QuestionListUtil.updateQuestionList(vote.question);
        v?.page = vote.page;
        v?.questionTotal = vote.questionTotal;
        v?.questionAnswered = vote.questionAnswered;
        v?.question!.addAll(vote.question!);
        vv = v!;
      }
    }

    print("vote.question::");
    printQuestionList(vv!.question!);
    print("questionShowing::");
    printQuestionList(QuestionListUtil.showingList!);
    return vv;
  }

  static setDebug(String debug) {
    DataUtils.debug = (debug == "true");
  }

  ///获取基础信息的答案json
  static String getBaseInfoFromMap(Map map, BaseInfo baseInfo) {
    BaseInfoResult baseInfoRes = new BaseInfoResult();
    if (baseInfo != null) {
      if (baseInfo.sex != null) {
        baseInfoRes.sex = map["sex"];
      }
      if (baseInfo.age != null) {
        baseInfoRes.age = map["age"];
      }
      if (baseInfo.work != null) {
        baseInfoRes.work = map["work"];
      }
      if (baseInfo.like != null) {
        baseInfoRes.like = map["like"];
      }
    }
    return json.encode(baseInfoRes);
  }

  ///获取问卷的答案json
  static String getVoteResultFromMap(Map? map, List<Question>? questionList) {
    List<result.QuestionResult> list = [];
    for (int i = 0; i < questionList!.length; i++) {
      //判断 原始问题ID，为基础信息项，直接跳过
      if (int.parse(questionList[i].questionId ?? "") < 0) continue;
      //构造答案单元
      result.QuestionResult questionRes = new result.QuestionResult();
      questionRes.questionId = questionList[i].questionId ?? "";
      if (map!.containsKey(questionList[i].questionId)) {
        QuestionListUtil.hasAnsweredQuestion
            .add(int.parse(questionList[i].questionId ?? ""));
        String answerFromMap = map[questionList[i].questionId].toString();
        //答案可能是多选题，需要对每个答案进行拆分
        List<String> answers =
            answerFromMap.replaceAll("[", "").replaceAll("]", "").split(",");
        List<result.Answer> answerList = [];
        for (int j = 0; j < answers.length; j++) {
          result.Answer a = new result.Answer();
          //问答题
          if ("3" == questionList[i].questionType) {
            a.answerText = answerFromMap;
            j = answers.length;
          } else {
            //单选 多选的选中条目id记录
            if ("" != answers[j]) a.answerId = int.parse(answers[j]);
            //单选多选的其他条目文本部分
            String key = new StringBuffer(
                    questionRes.questionId! + "_" + answers[j].trim())
                .toString();
            if (map.containsKey(key)) {
              a.answerText = map[key];
            }
          }
          answerList.add(a);
        }
        questionRes.answers = answerList;
      } else {
        questionRes.answers = [];
      }
      list.add(questionRes);
    }
    return json.encode(list);
  }

  ///获取服务器返回的Response实体
  static Response getResponseFromJSON(String voteJson) {
    DataUtils.printMsg("服务器获取到的VoteJson内容:$voteJson");
    Map<String, dynamic> map = json.decode(voteJson);
    return Response.fromJson(map);
  }

  ///检查答案是否没有填
  static int checkResult(Map map, Vote vote, List<bool> widgetStates,
      List<Question> questionList) {
    BaseInfo baseInfo = vote.baseInfo!;
    if (baseInfo != null) checkBaseInfo(map, baseInfo);
    return checkQuestion(map, questionList, widgetStates);
  }

  ///检查基础信息的答案
  static void checkBaseInfo(Map map, BaseInfo baseInfo) {
    if (baseInfo != null) {
      if (baseInfo.sex != null &&
          ((!map.containsKey("sex")) ||
              map["sex"] == null ||
              map["sex"] == "")) {
        map["sex"] = 0;
      }
      if (baseInfo.age != null &&
          ((!map.containsKey("age")) ||
              map["age"] == null ||
              map["age"] == "")) {
        map["age"] = 0;
      }
      if (baseInfo.work != null &&
          ((!map.containsKey("work")) || map["work"] == null)) {
        map["work"] = "";
      }
      if (baseInfo.like != null &&
          ((!map.containsKey("like")) || map["like"] == null)) {
        map["like"] = "";
      }
    }
  }

  ///检查问卷问题的答案，返回没有填的问题序号
  static int checkQuestion(
      Map map, List<Question> questionList, List<bool> widgetStates) {
    //DataUtils.print("questionList-----${questionList.length}");
    for (int i = 0; i < questionList.length; i++) {
      Question question = questionList[i];
      //如果问题为空白题目则直接跳过检查
      if (question.questionType == "6" || !question.required) continue;
      //某个问题没有答案记录
      if (!map.containsKey(question.questionId) ||
          map[question.questionId] == null ||
          map[question.questionId].toString().trim() == "") {
        widgetStates[i] = false;
        return i;
      }
      if (question.questionType == "3") continue;
      String answerFromMap = map[question.questionId].toString();
      List<Answer> answerList = question.answer ?? [];
      List<String> answers = answerFromMap
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll(" ", "")
          .split(",");
      //多选题取消掉了题目的情况，多选题选项超出数目限制
      if (answers[0].trim() == "" ||
          (question.questionLimit != "0" &&
              answers.length > int.parse(question.questionLimit ?? ""))) {
        widgetStates[i] = false;
        return i;
      }
      //多选题其他条目的判断
      for (int j = 0; j < answerList.length; j++) {
        Answer answer = answerList[j];
        if (answer.answerType == "3" &&
            !answer.optional &&
            answers.contains(answer.anwerId.toString())) {
          String key = new StringBuffer(
                  question.questionId! + "_" + answer.anwerId.toString())
              .toString();
          if (!map.containsKey(key) ||
              map[key] == null ||
              map[key].toString().trim() == "") {
            widgetStates[i] = false;
            return i;
          }
        }
      }
    }
    return -1;
  }

  ///将基础信息封装成Question实体
  static Question getBaseInfoQuestion(List list, Map textMap, int index) {
    if (index > -1 && index < list.length) {
      Question question = new Question();
      question.questionId = list[index];
      question.index = (index - 100).toString();
      question.required = false;
      question.questionName = textMap[list[index]];
      if (textMap.containsKey(list[index] + 'Option')) {
        question.questionType = "4";
        question.answer = [];
        List sexList = textMap[list[index] + 'Option'];
        for (int i = 0; i < sexList.length; i++) {
          Answer answer = new Answer();
          answer.anwerId = i;
          answer.answerName = sexList[i];
          question.answer?.add(answer);
        }
      } else {
        question.questionType = "5";
      }
      return question;
    }
    return new Question();
  }

  static Map<String, Question> map = new Map();

  ///打印vote的详细信息
  static void printVote(Vote vote) {
    DataUtils.printMsg(
        "vote----voteTitle:${vote.voteTitle}+voteId:${vote.voteId}");
    DataUtils.printMsg("baseinfo:${vote.baseInfo == null}");
    DataUtils.printMsg("question:${vote.question!.length}");
    printQuestionList(vote.question!);
  }

  ///打印问题列表
  static void printQuestionList(List<Question> questionList) {
    for (int i = 0; i < questionList.length; i++) {
      Question question = questionList[i];
      DataUtils.printMsg("question$i:\n$question");
    }
  }

  /// 打印debug代码
  static void printMsg(String msg) {
    if (debug) {
      print(msg);
    }
  }

  ///清除互斥项的答案
  static void clearMutexAnswer(Map map, Question question, String mutex) {
    List answerList = map[question.questionId];
    if (answerList != null && answerList.length > 0) {
      for (int i = 0; i < question.answer!.length; i++) {
        if (question.answer?[i].mutex != mutex &&
            answerList.contains(question.answer?[i].anwerId)) {
          question.lastAnswerId = question.answer![i].anwerId!;
          answerList.remove(question.answer?[i].anwerId);
          if (question.answer?[i].answerType == '3')
            map.remove(StringBuffer(question.questionId! +
                    '_' +
                    question.answer![i].anwerId.toString())
                .toString());
          //调用一次分支调整
          QuestionListUtil.changeQuestionList(question, map);
        }
      }
    }
  }
}
