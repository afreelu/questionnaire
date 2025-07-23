class BaseInfoResult {
  int? sex;
  int? age;
  String? like;
  String? work;

  BaseInfoResult({this.sex, this.age, this.like, this.work});

  BaseInfoResult.fromJson(Map<String, dynamic> json) {
    sex = json['sex'];
    age = json['age'];
    like = json['like'];
    work = json['work'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sex != null) data['sex'] = this.sex;
    if (this.age != null) data['age'] = this.age;
    if (this.like != null) data['like'] = this.like;
    if (this.work != null) data['work'] = this.work;
    return data;
  }
}
