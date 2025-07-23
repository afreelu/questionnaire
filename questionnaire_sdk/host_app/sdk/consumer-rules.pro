# Consumer ProGuard rules for QuestionnairSdk

# Keep QuestionnairSdk public API
-keep public class com.kunlun.platform.android.questionnair.QuestionnairSdk {
    public *;
}

-keep public interface com.kunlun.platform.android.questionnair.QuestionnairSdk$QuestionnairListioner {
    public *;
}

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**