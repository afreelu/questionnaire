import 'package:flutter/material.dart';
import 'package:questionnaire_sdk/bean/questionindex.dart';
import 'package:questionnaire_sdk/bean/vote.dart';
import 'package:questionnaire_sdk/utils/dataUtils.dart';

///实时保存和修改要显示题目信息和进度条的工具类
class QuestionListUtil {
  static List<Question>? showingList;
  static Map<String, Question>? questionMap;
  static List<Question>? originalList;
  static Map<int, String>? answer2questionMap;
  static Map<String, QuestionIndex>? weightMap;
  static double totalWeight = 0;
  static double currentWeight = 0;
  static Set<int> hasAnsweredQuestion = new Set();
  static Set<int> hasAnsweredAnswer = new Set();
  static Set<int> preShowingList = new Set();
  static Set<int> mainQuestions = new Set();
  static int startIndex = 1;

  static Map<dynamic, dynamic>? answerMap;

  static void initIndicator(Map questionMap) {
    // print("questionMap::$questionMap");
    weightMap = new Map();
    answer2questionMap = new Map();
    totalWeight = 0;
    //1.先将服务器传过来的json串转化为我们想要的数据格式
    questionMap.forEach((key, value) {
      QuestionIndex questionIndex = new QuestionIndex();
      questionIndex.questionId = key;
      DataUtils.printMsg("解析的json中map的value值:$value");
      Map? answerMap = value;
      if (answerMap != null) {
        questionIndex.answerIndex = [];
        answerMap.forEach((key, value) {
          AnswerIndex answerIndex = new AnswerIndex();
          answerIndex.answerId = int.parse(key);
          answerIndex.gotoQuestion = value.cast<int>();
          questionIndex.answerIndex?.add(answerIndex);
          answer2questionMap?[answerIndex.answerId!] =
              questionIndex.questionId!;
        });
      }
      weightMap?[key] = questionIndex;
    });
    weightMap!.forEach((key, value) {
      QuestionIndex questionIndex = value;
      if (mainQuestions.contains(int.parse(questionIndex.questionId!)))
        questionIndex.hierarchy = 1;
      if (questionIndex.answerIndex != null)
        questionIndex.answerIndex!.forEach((answerIndex) {
          if (answerIndex.gotoQuestion != null)
            answerIndex.gotoQuestion!.forEach((element) {
              if (weightMap!.containsKey(element.toString())) {
                weightMap?[element.toString()]
                    ?.answerList
                    .add(answerIndex.answerId!);
              }
            });
        });
    });
    print("1.转化为我们想要的数据格式后：\nweightMap::$weightMap");

    //4.计算总权重(主干题目权重之和)和当前已答题目权重
    weightMap?.forEach((key, value) {
      if (mainQuestions.contains(int.parse(key)) ||
          hasAnsweredQuestion.contains(int.parse(key)))
        totalWeight += value.weight;
    });
    print("4.计算总权重：$totalWeight");
  }

  static void adjustQustionList(bool isFirst) {
    print("adjustQustionList：$isFirst");
    //根据已选择选项修改正在展示的题目列表
    for (int i = 0; i < hasAnsweredAnswer.length; i++) {
      int answerId = hasAnsweredAnswer.elementAt(i);
      if (!weightMap!.containsKey(answer2questionMap?[answerId])) continue;
      //找到答案对应的questionIndex
      QuestionIndex questionIndex = weightMap![answer2questionMap?[answerId]]!;
      for (int i = 0; i < questionIndex.answerIndex!.length; i++) {
        if (questionIndex.answerIndex![i].answerId == answerId) {
          //将要显示的分支题目都找出来
          questionIndex.answerIndex![i].gotoQuestion!.forEach((questionId) {
            if (!hasAnsweredQuestion.contains(questionId) &&
                questionMap!.containsKey(questionId.toString()) &&
                !mainQuestions.contains(questionId)) {
              Question question = questionMap![questionId.toString()]!;
              question.hide = "0";
              weightMap?[question.questionId]?.hierarchy = 1;
              question.semaphore = 10000;
              if (isFirst) totalWeight++;
            }
          });
        }
      }
    }
    initShowingList();
    currentWeight = hasAnsweredQuestion.length.toDouble();
    startIndex = hasAnsweredQuestion.length;
    // print("totalWeight：$totalWeight,currentWeight：$currentWeight");
  }

  ///根据输入进的题目列表生成要显示的题目列表
  static createQuestionList(
      List<Question>? questions,
      Set<int>? currentShowedQuestion,
      Set<int>? currentAnswered,
      Map questionIndexMap,
      List<int>? mainQuestions) {
    DataUtils.printMsg(
        "questions:$questions \n currentShowedQuestion:$currentShowedQuestion \n currentAnswered:$currentAnswered \n questionIndexMap:$questionIndexMap \n mainQuestions:$mainQuestions");
    if (questions == null || questions.length == 0) return;
    if (currentShowedQuestion != null)
      hasAnsweredQuestion.addAll(currentShowedQuestion);
    if (currentAnswered != null) hasAnsweredAnswer.addAll(currentAnswered);
    originalList = [];
    originalList?.addAll(questions);
    questionMap = {};
    bool flag = false;
    if (showingList == null) flag = true;
    showingList = [];
    for (int i = 0; i < questions.length; i++) {
      String questionId = questions[i].questionId ?? "";
      questionMap![questionId] = questions[i];
      //不隐藏的题目就是首次要展示的题目
      if (questions[i].hide == "0") showingList?.add(questions[i]);
    }
    if (flag) {
      QuestionListUtil.mainQuestions.addAll(mainQuestions!);
      initIndicator(questionIndexMap);
    }
    adjustQustionList(flag);
  }

  static updateQuestionList(List<Question>? questions) {
    if (questions == null || questions.length == 0) return;
    for (int i = 0; i < questions.length; i++) {
      if (questionMap!.containsKey(questions[i].questionId)) continue;
      originalList?.add(questions[i]);
      String questionId = questions[i].questionId ?? "";
      questionMap?[questionId] = questions[i];
      if (questions[i].hide == "0") showingList?.add(questions[i]);
    }
  }

  ///要取消这个题目的显示信号量
  static shrinkQuestion(Question parent, Question question, Map answerMap) {
    // if(question == null || (question.questionType != "1" && question.questionType != "2")) return;
    if (question == null)
      return
          //执行取消本题目的显示信号量
          print('执行shrinkQuestion');
    if (question.semaphore! > 0) {
      question.semaphore = question.semaphore! - 1;
      question.parentList.remove(parent);
      // print("semaphore--::$question");
    }
    if (!showingList!.contains(question)) return;
    //如果该问题可以连到主干题目，就不做处理，否则所有链接的题目都要删除
    print("${question.questionId}判断环路");
    if (question.semaphore! > 0 && offTrunk(question)) {
      print("${question.questionId}有环路，进行环路删除");
      question.semaphore = 0;
      question.parentList.clear();
      showingList?.forEach((element) {
        element.flag = "0";
      });
    }
    if (question.semaphore == 0) {
      //利用递归先把子分支的题目取消了
      question.lastAnswerId = -1;
      showingList?.remove(question);
      question.hide = "1";
      print("删除问题${question.questionId}");
      for (int i = 0; i < question.answer!.length; i++) {
        //如果选项被选中就收缩选项对应的题目
        if ((question.questionType == "1" &&
                answerMap.containsKey(question.questionId) &&
                answerMap[question.questionId] ==
                    question.answer![i].anwerId) ||
            (question.questionType == "2" &&
                answerMap.containsKey(question.questionId) &&
                answerMap[question.questionId]
                    .contains(question.answer![i].anwerId)) ||
            (question.questionType == "11" &&
                answerMap.containsKey(question.questionId) &&
                answerMap[question.questionId] == question.answer![i].anwerId))
          hasAnsweredAnswer.remove(question.answer![i].anwerId);
        shrink(question, question.answer![i], answerMap);
      }
      totalWeight--;
      if (answerMap.containsKey(question.questionId)) {
        if (question.questionType == "1" ||
            question.questionType == "11" ||
            (question.questionType == "2" &&
                answerMap[question.questionId].length > 0)) currentWeight--;
      }
      answerMap.remove(question.questionId);
    }
  }

  static bool offTrunk(Question question) {
    print("判断环路开始${question.questionId}");
    bool result = true;
    if (weightMap?[question.questionId]!.hierarchy == 1) return false;
    question.flag = question.questionId ?? "";
    question.parentList.forEach((ques) {
      if (!search(question.questionId ?? "", ques)) result = false;
    });
    print("循环结束$result");
    return result;
  }

  static bool search(String originId, Question question) {
    print("搜索子问题${question.questionId}");
    bool result = true;
    if (weightMap![question.questionId]!.hierarchy == 1) return false;
    if (question.flag == originId) return true;
    question.flag = originId;
    question.parentList.forEach((ques) {
      if (!search(question.questionId ?? "", ques)) result = false;
    });
    print("搜索子问题${question.questionId}结束$result");
    return result;
  }

  ///取消选择某个答案后要收缩这个答案的分支题目
  static shrink(Question question, Answer answer, Map answerMap) {
    print("执行删除逻辑1");
    print(question.checkedId);
    print(answer.anwerId);
    if (answer.gotoQuestionId == null || answer.gotoQuestionId!.length == 0)
      return;
    print("执行删除逻辑");
    for (int i = 0; i < answer.gotoQuestionId!.length; i++) {
      shrinkQuestion(
          question, questionMap![answer.gotoQuestionId![i]]!, answerMap);
    }
  }

  ///选择某个答案后要扩展他指向的分支题目
  static expand(Question question, Answer answer) {
    DataUtils.printMsg("questionMap:$questionMap\n");
    DataUtils.printMsg("扩展题目:\nquestion$question\nanswer$answer\n");
    print(question.questionId);
    print(answer.anwerId);
    print(answer.gotoQuestionId);
    if (answer.gotoQuestionId == null || answer.gotoQuestionId!.length == 0)
      return;
    DataUtils.printMsg("扩展题目开始\n");
    for (int i = 0; i < answer.gotoQuestionId!.length; i++) {
      if (!showingList!.contains(questionMap?[answer.gotoQuestionId![i]]) &&
          !hasAnsweredQuestion.contains(int.parse(answer.gotoQuestionId![i])) &&
          !preShowingList.contains(int.parse(answer.gotoQuestionId![i]))) {
        if (!questionMap!.containsKey(answer.gotoQuestionId![i]))
          preShowingList.add(int.parse(question.questionId!));
        totalWeight++;
      }
      //要扩展的题目在下一页，本页就不做处理了,扩展题目是本身就不做扩展d
      if (hasAnsweredQuestion.contains(int.parse(answer.gotoQuestionId![i])) ||
          !questionMap!.containsKey(answer.gotoQuestionId![i]) ||
          questionMap?[answer.gotoQuestionId![i]] == question) {
        DataUtils.printMsg("进入选择一\n");
        continue;
      }
      //要扩展的题目在本题之前的话，直接在本题目后面显示出来
      if (originalList!.indexOf(question) >
          originalList!.indexOf(questionMap![answer.gotoQuestionId![i]]!)) {
        DataUtils.printMsg("进入选择二\n");
        if (!showingList!.contains(questionMap![answer.gotoQuestionId![i]])) {
          originalList?.remove(questionMap![answer.gotoQuestionId![i]]);
          originalList?.insert(originalList!.indexOf(question) + 1,
              questionMap![answer.gotoQuestionId![i]]!);
        }
      }
      questionMap![answer.gotoQuestionId![i]]!.parentList.add(question);
      questionMap![answer.gotoQuestionId![i]]!.hide = "0";
      initShowingList();
      //修改显示信号量
      questionMap![answer.gotoQuestionId![i]]!.semaphore =
          questionMap![answer.gotoQuestionId![i]]!.semaphore! + 1;
      print(questionMap![answer.gotoQuestionId![i]]!);
      DataUtils.printMsg("扩展题目结束\n");
    }
  }

  static void initShowingList() {
    DataUtils.printMsg("initShowingList \n");
    showingList!.clear();
    for (int i = 0; i < originalList!.length; i++) {
      if (originalList![i].hide == "0") showingList!.add(originalList![i]);
    }
  }

  // static Map answerMap;

  ///选中题目时尝试改变题目结构（还有进度条）
  static changeQuestionList(Question question, Map answerMap) {
    QuestionListUtil.answerMap = answerMap;
    //先删除旧题目分支，再添加新的
    for (int i = 0; i < question.answer!.length; i++) {
      if ((question.questionType == "1" &&
              question.lastAnswerId == question.answer![i].anwerId) ||
          (question.questionType == "2" &&
              question.checkedId == question.answer![i].anwerId &&
              !answerMap[question.questionId]
                  .contains(question.answer![i].anwerId)) ||
          (question.questionType == "11" &&
              question.lastAnswerId == question.answer![i].anwerId)) {
        hasAnsweredAnswer.remove(question.answer![i].anwerId);
        print("删除题目start");
        shrink(question, question.answer![i], answerMap);
        print("删除题目end");
        break;
      }
    }
    for (int i = 0; i < question.answer!.length; i++) {
      if ((question.questionType == "1" &&
              answerMap[question.questionId] == question.answer![i].anwerId) ||
          (question.questionType == "2" &&
              question.checkedId == question.answer![i].anwerId &&
              answerMap[question.questionId]
                  .contains(question.answer![i].anwerId)) ||
          (question.questionType == "11" &&
              answerMap[question.questionId] == question.answer![i].anwerId)) {
        hasAnsweredAnswer.add(question.answer![i].anwerId!);
        expand(question, question.answer![i]);
        break;
      }
    }
    //改变答题进度(有环的情况)
    if ((question.questionType == "1" && question.lastAnswerId == -1) ||
        (question.questionType == "2" &&
            question.lastAnswerId == -1 &&
            answerMap.containsKey(question.questionId) &&
            answerMap[question.questionId].length == 1) ||
        (question.questionType == "11" && question.lastAnswerId == -1) ||
        (question.questionType == "12" && question.lastAnswerId == -1) ||
        (question.questionType == "3" && question.lastAnswerId == -1)) {
      question.lastAnswerId = 0;
      currentWeight++;
    }
    if ((question.questionType == "2" &&
            answerMap.containsKey(question.questionId) &&
            answerMap[question.questionId].length == 0) ||
        (question.questionType == "3" && question.lastAnswerId == 1)) {
      question.lastAnswerId = -1;
      currentWeight--;
    }

    if (answerMap.isEmpty) {
      currentWeight = 0;
    }

    print("totalweight:$totalWeight,currentweight:$currentWeight");
  }
}
