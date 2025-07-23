///问卷的实体信息
class Vote {
  String? voteId; //问卷主题ID
  String? voteTitle; //问卷主题
  String? voteDesc; //问卷详细描述
  BaseInfo? baseInfo; //基础信息
  List<Question>? question; //问卷问题
  int? pageStyle; //分页形式 1=按钮 2=下拉
  int? pageTotal; //总页数
  int? questionTotal; //总题目数
  int? questionAnswered; //已答题目数
  List<int>? pageQuestionTotal; //每页总题数
  int? page; //当前页
  Set<int>? currentShowedQuestion; //当前已答的题目列表
  Set<int>? currentAnswered; //当前选中的分支答案
  Map questionMap = {}; //当前问卷所有的跳转关系表，用于进度条的计算和显示
  List<int>? mainQuestions;

  Vote({this.voteId, this.voteTitle, this.baseInfo, this.question});

  Vote.fromJson(Map<String, dynamic> json) {
    pageStyle = int.parse(json['page_style']);
    pageTotal = json['page_total'];
    page = json['page'];
    voteId = json['vote_id'];
    voteTitle = json['vote_title'];
    voteDesc = json['vote_desc'] != null ? json['vote_desc'] : "";
    Map<String, dynamic>? base_info =
        (json['base_info'] != null && json['base_info'] != "{}")
            ? json['base_info']
            : null;
    base_info = {};
    baseInfo = new BaseInfo.fromJson(base_info!);
    if (json['page_question_total'] != null) {
      pageQuestionTotal = [];
      json['page_question_total'].forEach((v) {
        pageQuestionTotal?.add(v);
      });
    }
    if (json['question'] != null) {
      question = [];
      json['question'].forEach((v) {
        question?.add(new Question.fromJson(v));
      });
    }
    if (json['question_goto_map'] != null) {
      questionMap = json['question_goto_map'];
    } else {
      questionMap = {};
    }
    if (json['main_questions'] != null) {
      mainQuestions = json['main_questions'].cast<int>();
    }
    if (json['answered_questions'] != null) {
      currentShowedQuestion = new Set();
      currentShowedQuestion?.addAll(json['answered_questions'].cast<int>());
    }
    if (json['answered_sub_answers'] != null) {
      currentAnswered = new Set();
      currentAnswered?.addAll(json['answered_sub_answers'].cast<int>());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_id'] = this.voteId;
    data['vote_title'] = this.voteTitle;
    if (this.baseInfo != null) {
      data['base_info'] = this.baseInfo?.toJson();
    }
    if (this.question != null) {
      data['question'] = this.question?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//基础信息bean类
class BaseInfo {
  bool? sex; //保密 男 女
  bool? age; //保密 under16 17-20 20-25 25-30 30-35 35-40 above40
  bool? work;
  bool? like;

  BaseInfo({this.sex, this.age, this.work, this.like});

  BaseInfo.fromJson(Map<String, dynamic> json) {
    sex = json['sex'];
    age = json['age'];
    work = json['work'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['work'] = this.work;
    data['like'] = this.like;
    return data;
  }
}

//问题的bean类
class Question {
  String? questionName; //问题名称
  String? questionId; //问题在数据库中的编号，在上报是要用
  String? index; //问题题目编号
  String? questionType; //问题类型 1单选 2复选 3文本框 4基础信息下拉框 5基础信息文本框 11下拉框 12星级
  String? questionBranch; //问题所属的分支
  String? noType; //编号类型 0：ABCD式  1：阿拉伯数字试   2：无编号  3罗马数字编号
  String? score; //分数/权重
  String? questionLimit; //答案数目限制
  String? hide; //是否隐藏题目
  int? semaphore; //是否展示题目，使用一个信号量来表示
  bool required = true; //题目是否必填
  int lastAnswerId = -1; //上一次所选中的答案(可以优化，写到点击回调参数里)
  int checkedId = -1; //多选题选中的答案(可以优化，写到点击回调参数里)
  List<Answer>? answer; //答案
  List<Question> parentList = [];
  String flag = "0";

  Question(
      {this.questionName,
      this.questionId,
      this.questionType,
      this.questionBranch,
      this.noType,
      this.score,
      this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    questionName = json['question_name'];
    questionId = json['question_id'];
    index = json['index'];
    questionType = json['question_type'];
    hide = json['hide'];
    semaphore = (hide == "0" ? 1 : 0);
    if (json['question_limit'] != null)
      questionLimit = json['question_limit'];
    else
      questionLimit = "0";
    noType = json['no_type'];
    score = json['score'];
    if (json['answer'] != null) {
      answer = [];
      json['answer'].forEach((v) {
        answer?.add(new Answer.fromJson(v));
      });
    }
    if (json['optional'] != null) required = (json['optional'] != '1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_name'] = this.questionName;
    data['question_id'] = this.questionId;
    data['question_type'] = this.questionType;
    data['question_branch'] = this.questionBranch;
    data['no_type'] = this.noType;
    data['score'] = this.score;
    if (this.answer != null) {
      data['answer'] = this.answer?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "{questionId:$questionId,questionName:$questionName,index:$index,questionType:$questionType,"
        "questionLimit:$questionLimit,hide:$hide,semaphore:$semaphore,answers:$answer,parentlist:${parentList.length}}\n";
  }
}

//单选多选的答案类
class Answer {
  int? anwerId; //题目id
  String? answerName; //题目
  String?
      answerType; //1单选 2复选 3文本框；注意如果题目表里是单选，则全应为单选，可定义单选答案为文本做为其它选项，同理复选也是 4图片
  String? answerNo; //答案序号
  String? answerUrl; //答案图片的地址
  String? answerBranch; //答案定位的分支
  bool optional = false; //答案是否必填，类型是3的时候可选项（目前还没有需求，作为预留字段）
  List<String>? gotoQuestionId; //选中后要显示的题目
  bool clickable = true; //是否可点击
  String mutex = "0"; //互斥选项标识 1=互斥选项   0=普通选项

  Answer(
      {this.anwerId,
      this.answerName,
      this.answerType,
      this.answerNo,
      this.answerBranch});

  Answer.fromJson(Map<String, dynamic> json) {
    anwerId = int.parse(json['answer_id']);
    answerName = json['answer_name'];
    answerType = json['answer_type'];
    answerNo = json['answer_no'];
    answerBranch = json['answer_branch'];
    if (json['goto_question_id'] != null) {
      gotoQuestionId = [];
      json['goto_question_id'].forEach((v) {
        gotoQuestionId?.add(v);
      });
    }
    if (json['optional'] != null) optional = (json['optional'] == '1');
    if (json['image_url'] != null) answerUrl = json['image_url'];
    if (json['mutex'] != null) mutex = json['mutex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anwer_id'] = this.anwerId;
    data['answer_name'] = this.answerName;
    data['answer_type'] = this.answerType;
    data['answer_no'] = this.answerNo;
    data['answer_branch'] = this.answerBranch;
    return data;
  }

  @override
  String toString() {
    return "{anwerId:$anwerId,answerName:$answerName,answerType:$answerType,answerUrl:$answerUrl,"
        "gotoQuestionId:$gotoQuestionId,mutex:$mutex}\n";
  }
}
