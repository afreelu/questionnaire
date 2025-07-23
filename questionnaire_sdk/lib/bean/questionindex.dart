class QuestionIndex {
  String? questionId;
  double weight = 1;
  int hierarchy = 0; //问题所在的层级
  List<int> answerList = []; //记录父节点数目
  List<AnswerIndex>? answerIndex;
  bool flag = false;
  double coefficient = 0;
  int checked = 0;
  @override
  String toString() {
    return "{questionId:$questionId,weight:$weight,answerIndex$answerIndex,answerList$answerList,coefficient:$coefficient}";
  }
}

class AnswerIndex {
  int? answerId;
  double weight = 0;
  List<int>? gotoQuestion;
  @override
  String toString() {
    return "{answerId:$answerId,weight:$weight,gotoQuestion$gotoQuestion}";
  }
}
