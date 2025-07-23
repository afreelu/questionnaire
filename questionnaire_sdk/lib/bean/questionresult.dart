class QuestionResult {
  String? questionId;
  List<Answer>? answers;

  QuestionResult({this.questionId, this.answers});

  QuestionResult.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    if (this.answers != null) {
      data['answers'] = this.answers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  int? answerId;
  String? answerText;

  Answer({this.answerId, this.answerText});

  Answer.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    answerText = json['answer_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answerId != null) data['answer_id'] = this.answerId;
    if (this.answerText != null) data['answer_text'] = this.answerText;
    return data;
  }
}
