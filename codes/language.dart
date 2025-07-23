class Language {
  Map languageMap = {};
  static Language? language;
  static String? lang;
  static Map? getText(String? lang) {
    lang = lang?.toLowerCase();
    Language.lang = lang;
    if (lang == "en")
      language = new LangEN();
    else if ("cn" == lang || "zh-cn" == lang)
      language = new LangCN();
    else if ("de" == lang)
      language = new LangDE();
    else if ("fr" == lang)
      language = new LangFR();
    else if ("it" == lang)
      language = new LangIT();
    else if ("ru" == lang)
      language = new LangRU();
    else if ("tr" == lang)
      language = new LangTR();
    else if ("pt" == lang)
      language = new LangPT();
    else if ("es" == lang)
      language = new LangES();
    else if ("vn" == lang)
      language = new LangVN();
    else if ("th" == lang)
      language = new LangTH();
    else if ("id" == lang)
      language = new LangID();
    else {
      Language.lang = "en";
      language = new LangEN();
    }
    return language?.languageMap;
  }

  static getLang() {
    return lang;
  }
}

//大陆简体
class LangCN extends Language {
  LangCN() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "请选择一个选项";
  }
}

//英语
class LangEN extends Language {
  LangEN() {
    languageMap = new Map();
    languageMap["submit"] = "Submit";
    languageMap["age"] = "Your Age:";
    List ageList = [];
    ageList.add("Secret");
    ageList.add("Below 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40 and above");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Your Gender:";
    List sexList = [];
    sexList.add("Secret");
    sexList.add("Male");
    sexList.add("Female");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Profession:";
    languageMap["like"] = "Hobby:";
    languageMap["loading"] = "Loading...";
    languageMap["noFill"] = "You haven't filled in all options";
    languageMap["survey"] = "Survey";
    languageMap['next_page'] = "Next";
    languageMap['last_page'] = "Prev";
    languageMap['network_error'] =
        "The network connection is unstable. Please check the network and try again.";
    languageMap['dropdown_notice'] = "Please select an option";
  }
}

//台湾繁体
class LangTW extends Language {
  LangTW() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap?["ageOption"] = ageList;
    languageMap?["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "請選擇一項";
  }
}

//韩语
class LangKR extends Language {
  LangKR() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "옵션 하나를 선택하십시오";
  }
}

//日语
class LangJP extends Language {
  LangJP() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "1つ選んで下さい";
  }
}

//越南
class LangVN extends Language {
  LangVN() {
    languageMap = new Map();
    languageMap["submit"] = "Gửi";
    languageMap["age"] = "Hãy chọn năm sinh";
    List ageList = [];
    ageList.add("Bảo mật");
    ageList.add("Dưới 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Trên 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Hãy chọn giới tính";
    List sexList = [];
    sexList.add("Bảo mật");
    sexList.add("Nam");
    sexList.add("Nữ");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Công việc: ";
    languageMap["like"] = "Sở thích: ";
    languageMap["loading"] = "Đang tải...";
    languageMap["noFill"] = "Vẫn còn hạng mục chưa điều";
    languageMap["survey"] = "Khảo Sát";
    languageMap['next_page'] = "Sau";
    languageMap['last_page'] = "Trước";
    languageMap['network_error'] =
        "Mạng không ổn định, hãy kiểm tra đường truyền rồi thử lại!";
    languageMap['dropdown_notice'] = "Hãy chọn 1 mục";
  }
}

//泰语
class LangTH extends Language {
  LangTH() {
    languageMap = new Map();
    languageMap["submit"] = "ส่ง";
    languageMap["age"] = "โปรดเลือกอายุ";
    List ageList = [];
    ageList.add("ความลับ");
    ageList.add("น้อยกว่า16ปี");
    ageList.add("17-20ปี");
    ageList.add("20-25ปี");
    ageList.add("25-30ปี");
    ageList.add("30-35ปี");
    ageList.add("35-40ปี");
    ageList.add("40ขึ้นไป");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "โปรดเลือกเพศ";
    List sexList = [];
    sexList.add("ความลับ");
    sexList.add("ชาย");
    sexList.add("หญิง");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "ทำงาน:";
    languageMap["like"] = "งานอดิเรก:";
    languageMap["loading"] = "กําลังโหลด...";
    languageMap["noFill"] = "ท่านมีตัวเลือกที่ยังไม่ได้กรอก";
    languageMap["survey"] = "แบบสอบถาม";
    languageMap['next_page'] = "หน้าถัดไป";
    languageMap['last_page'] = "หน้าก่อน";
    languageMap['network_error'] =
        "เครือข่ายปัจจุบันไม่ดี โปรดตรวจสอบเครือข่ายและลองใหม่อีกครั้ง";
    languageMap['dropdown_notice'] = "โปรดเลือกตัวเลือก";
  }
}

//德语
class LangDE extends Language {
  LangDE() {
    languageMap = new Map();
    languageMap["submit"] = "Senden";
    languageMap["age"] = "Dein Alter:";
    List ageList = [];
    ageList.add("Will es nicht angeben");
    ageList.add("Unter 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Über 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Dein Geschlecht:";
    List sexList = [];
    sexList.add("Will es nicht angeben");
    sexList.add("Männlich");
    sexList.add("Weiblich");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Arbeit:";
    languageMap["like"] = "Hobbies:";
    languageMap["loading"] = "Laden...";
    languageMap["noFill"] = "Du hast nicht alle Optionen ausgefüllt";
    languageMap["survey"] = "Umfrage";
    languageMap['next_page'] = "Vorherige";
    languageMap['last_page'] = "Nächste";
    languageMap['network_error'] =
        "Die Netzwerkverbindung ist instabil. Bitte überprüfe das Netzwerk und versuche es erneut.";
    languageMap['dropdown_notice'] = "Bitte wähle eine Option";
  }
}

//印尼
class LangID extends Language {
  LangID() {
    languageMap = new Map();
    languageMap["submit"] = "Submit";
    languageMap["age"] = "Umurmu";
    List ageList = [];
    ageList.add("Rahasia");
    ageList.add("Dibawah 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Diatas 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Jenis Kelamin";
    List sexList = [];
    sexList.add("Rahasia");
    sexList.add("Laki-Laki");
    sexList.add("Perempuan");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Pekerjaan:";
    languageMap["like"] = "Hobi:";
    languageMap["loading"] = "Loading...";
    languageMap["noFill"] = "Kamu belum mengisi semua pilihan";
    languageMap["survey"] = "Survei";
    languageMap['next_page'] = "Selanjutnya";
    languageMap['last_page'] = "Sebelumnya";
    languageMap['network_error'] =
        "Jaringan saat ini tidak baik, silahkan periksa jaringan kamu dan coba lagi nanti";
    languageMap['dropdown_notice'] = "Silahkan pilih";
  }
}

//法语
class LangFR extends Language {
  LangFR() {
    languageMap = new Map();
    languageMap["submit"] = "Envoyer";
    languageMap["age"] = "Votre Âge :";
    List ageList = [];
    ageList.add("Secret");
    ageList.add("Moins de 16 ans");
    ageList.add("17-20 ans");
    ageList.add("20-25 ans");
    ageList.add("25-30 ans");
    ageList.add("30-35 ans");
    ageList.add("35-40 ans");
    ageList.add("40 ans et plus");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Votre Sexe :";
    List sexList = [];
    sexList.add("Secret");
    sexList.add("Masculin");
    sexList.add("Féminin");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Emploi :";
    languageMap["like"] = "Loisirs :";
    languageMap["loading"] = "Chargement...";
    languageMap["noFill"] = "Vous n'avez pas rempli toutes les options";
    languageMap["survey"] = "Enquête";
    languageMap['next_page'] = "Page Suivante";
    languageMap['last_page'] = "Page Précédente";
    languageMap['network_error'] =
        "Le réseau actuel est instable, veuillez vérifier votre réseau et réessayer.";
    languageMap['dropdown_notice'] = "Veuillez sélectionner une option";
  }
}

//意大利语
class LangIT extends Language {
  LangIT() {
    languageMap = new Map();
    languageMap["submit"] = "Invia";
    languageMap["age"] = "Età:";
    List ageList = [];
    ageList.add("Segreto");
    ageList.add("Minore di 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Maggiore di 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Genere:";
    List sexList = [];
    sexList.add("Segreto");
    sexList.add("Uomo");
    sexList.add("Donna");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Lavoro:";
    languageMap["like"] = "Hobby:";
    languageMap["loading"] = "Caricamento...";
    languageMap["noFill"] = "Non hai ancora risposto a tutte le opzioni";
    languageMap["survey"] = "Sondaggio";
    languageMap['next_page'] = "Avanti";
    languageMap['last_page'] = "Indietro";
    languageMap['network_error'] =
        "La connessione non è buona. Controlla la connessione e riprova.";
    languageMap['dropdown_notice'] = "Seleziona un'opzione";
  }
}

//俄语
class LangRU extends Language {
  LangRU() {
    languageMap = new Map();
    languageMap["submit"] = "Отправить";
    languageMap["age"] = "Ваш возраст:";
    List ageList = [];
    ageList.add("Секрет");
    ageList.add("До 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40 и старше");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Ваш пол:";
    List sexList = [];
    sexList.add("Секрет");
    sexList.add("Муж.");
    sexList.add("Жен.");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Работа:";
    languageMap["like"] = "Хобби:";
    languageMap["loading"] = "Загрузка...";
    languageMap["noFill"] = "Вы не всё заполнили";
    languageMap["survey"] = "Опрос";
    languageMap['next_page'] = "Далее";
    languageMap['last_page'] = "Назад";
    languageMap['network_error'] =
        "Нестабильное сетевое соединение. Пожалуйста, проверьте сетевое подключение.";
    languageMap['dropdown_notice'] = "Выберите один пункт";
  }
}

//土耳其语
class LangTR extends Language {
  LangTR() {
    languageMap = new Map();
    languageMap["submit"] = "Gönder";
    languageMap["age"] = "Lütfen Yaşınızı Seçiniz";
    List ageList = [];
    ageList.add("Sır");
    ageList.add("16 altı");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40 üstü");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Lütfen Cinsiyetinizi Seçiniz";
    List sexList = [];
    sexList.add("Sır");
    sexList.add("Erkek");
    sexList.add("Kadın");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "İşiniz:";
    languageMap["like"] = "Hobileriniz:";
    languageMap["loading"] = "Yükleniyor...";
    languageMap["noFill"] = "Doldurmadığınızı biryer var";
    languageMap["survey"] = "Anket";
    languageMap['next_page'] = "Sonraki";
    languageMap['last_page'] = "Önceki";
    languageMap['network_error'] =
        "Mevcut internet ağı iyi değil, lütfen ağı kontrol edin ve tekrar deneyin";
    languageMap['dropdown_notice'] = "Lütfen bir seçeneği seçiniz";
  }
}

//葡萄牙语
class LangPT extends Language {
  LangPT() {
    languageMap = new Map();
    languageMap["submit"] = "Submeter";
    languageMap["age"] = "Idade:";
    List ageList = [];
    ageList.add("Segredo");
    ageList.add("Abaixo de 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Acima de 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Género:";
    List sexList = [];
    sexList.add("Segredo");
    sexList.add("Masculino");
    sexList.add("Feminino");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Ocupação:";
    languageMap["like"] = "Passatempos:";
    languageMap["loading"] = "Carregando...";
    languageMap["noFill"] = "Não preencheu todas as opções";
    languageMap["survey"] = "Inquérito";
    languageMap['next_page'] = "Página Seguinte";
    languageMap['last_page'] = "Página Anterior";
    languageMap['network_error'] =
        "Conexão instável. Verifique a sua conexão e volte a tentar.";
    languageMap['dropdown_notice'] = "Selecione uma opção";
  }
}

//阿拉伯语
class LangAR extends Language {
  LangAR() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = " الرجاء تحديد خيار";
  }
}

//荷兰语
class LangNL extends Language {
  LangNL() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "请选择一个选项";
  }
}

//西班牙语
class LangES extends Language {
  LangES() {
    languageMap = new Map();
    languageMap["submit"] = "Enviar";
    languageMap["age"] = "Edad:";
    List ageList = [];
    ageList.add("Secreto");
    ageList.add("Menor de 16");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("Mayor de 40");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "Género:";
    List sexList = [];
    sexList.add("Secreto");
    sexList.add("Masculino");
    sexList.add("Femenino");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "Profesión:";
    languageMap["like"] = "Hobby:";
    languageMap["loading"] = "Cargando...";
    languageMap["noFill"] = "No has rellenado todas las opciones";
    languageMap["survey"] = "Encuesta";
    languageMap['next_page'] = "Siguiente";
    languageMap['last_page'] = "Anterior";
    languageMap['network_error'] =
        "La conexión actual no es buena, favor de verificar la red e intentar de nuevo";
    languageMap['dropdown_notice'] = "Favor de seleccionar una opción";
  }
}

//波兰语
class LangPL extends Language {
  LangPL() {
    languageMap = new Map();
    languageMap["submit"] = "提交";
    languageMap["age"] = "请选择年龄";
    List ageList = [];
    ageList.add("保密");
    ageList.add("16以下");
    ageList.add("17-20");
    ageList.add("20-25");
    ageList.add("25-30");
    ageList.add("30-35");
    ageList.add("35-40");
    ageList.add("40以上");
    languageMap["ageOption"] = ageList;
    languageMap["sex"] = "请选择性别";
    List sexList = [];
    sexList.add("保密");
    sexList.add("男");
    sexList.add("女");
    languageMap["sexOption"] = sexList;
    languageMap["work"] = "工作:";
    languageMap["like"] = "爱好:";
    languageMap["loading"] = "加载中...";
    languageMap["noFill"] = "您还有选项没有填";
    languageMap["survey"] = "问卷调查";
    languageMap['next_page'] = "下一页";
    languageMap['last_page'] = "上一页";
    languageMap['network_error'] = "当前网络不佳，请检查网络后重试";
    languageMap['dropdown_notice'] = "Proszę wybierz opcję";
  }
}
