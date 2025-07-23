# API参考文档

## QuestionnairSdk 类

### 概述

`QuestionnairSdk` 是问卷调查SDK的主要入口类，提供初始化、配置和启动问卷调查的功能。

### 静态方法

#### init(Context context)

初始化SDK，必须在Application的onCreate方法中调用。

**参数:**
- `context`: Application上下文

**示例:**
```java
QuestionnairSdk.init(this);
```

#### setResultListener(ResultListener listener)

设置问卷调查结果监听器。

**参数:**
- `listener`: 结果监听器实例

**示例:**
```java
QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
    @Override
    public void onSuccess(String result) {
        // 处理成功结果
    }
    
    @Override
    public void onError(String error) {
        // 处理错误
    }
    
    @Override
    public void onCancel() {
        // 处理取消
    }
});
```

### Builder 类

用于构建问卷调查配置的建造者模式类。

#### 构造方法

```java
QuestionnairSdk.Builder()
```

#### 配置方法

##### setUserId(String userId)

设置用户ID。

**参数:**
- `userId`: 用户唯一标识符

**返回值:** Builder实例

##### setQuestionnaireId(String questionnaireId)

设置问卷ID。

**参数:**
- `questionnaireId`: 问卷唯一标识符

**返回值:** Builder实例

##### setServerUrl(String serverUrl)

设置服务器API地址。

**参数:**
- `serverUrl`: 完整的API服务器地址

**返回值:** Builder实例

##### setLanguage(String language)

设置语言。

**参数:**
- `language`: 语言代码，如"zh-CN"、"en-US"

**返回值:** Builder实例

##### setTheme(String theme)

设置主题。

**参数:**
- `theme`: 主题名称

**返回值:** Builder实例

##### setTimeout(int timeout)

设置网络超时时间。

**参数:**
- `timeout`: 超时时间（秒）

**返回值:** Builder实例

##### build()

构建配置对象。

**返回值:** QuestionnairConfig配置对象

**示例:**
```java
QuestionnairSdk.Builder builder = new QuestionnairSdk.Builder()
    .setUserId("user123")
    .setQuestionnaireId("questionnaire456")
    .setServerUrl("https://api.example.com")
    .setLanguage("zh-CN")
    .setTimeout(60);

QuestionnairConfig config = builder.build();
```

## QuestionnairActivity 类

### 概述

`QuestionnairActivity` 是显示问卷调查界面的Activity类。

### 静态方法

#### start(Context context, QuestionnairConfig config)

启动问卷调查Activity。

**参数:**
- `context`: 上下文
- `config`: 问卷配置对象

**示例:**
```java
QuestionnairConfig config = new QuestionnairSdk.Builder()
    .setUserId("user123")
    .setQuestionnaireId("questionnaire456")
    .setServerUrl("https://api.example.com")
    .build();

QuestionnairActivity.start(this, config);
```

## ResultListener 接口

### 概述

问卷调查结果监听器接口。

### 方法

#### onSuccess(String result)

问卷调查成功完成时调用。

**参数:**
- `result`: JSON格式的问卷结果数据

#### onError(String error)

发生错误时调用。

**参数:**
- `error`: 错误信息

#### onCancel()

用户取消问卷调查时调用。

## QuestionnairConfig 类

### 概述

问卷调查配置类，包含所有配置参数。

### 属性

| 属性名 | 类型 | 说明 |
|--------|------|------|
| userId | String | 用户ID |
| questionnaireId | String | 问卷ID |
| serverUrl | String | 服务器地址 |
| language | String | 语言设置 |
| theme | String | 主题设置 |
| timeout | int | 超时时间 |

### 方法

#### getUserId()

获取用户ID。

**返回值:** String

#### getQuestionnaireId()

获取问卷ID。

**返回值:** String

#### getServerUrl()

获取服务器地址。

**返回值:** String

#### getLanguage()

获取语言设置。

**返回值:** String

#### getTheme()

获取主题设置。

**返回值:** String

#### getTimeout()

获取超时时间。

**返回值:** int

## 工具类

### KunlunSdkUtil

提供Kunlun SDK相关的工具方法。

#### 静态方法

##### isKunlunSdkAvailable()

检查Kunlun SDK是否可用。

**返回值:** boolean

##### initKunlunSdk(Context context)

初始化Kunlun SDK（如果可用）。

**参数:**
- `context`: 上下文

**返回值:** boolean - 初始化是否成功

### KunlunSwiftUtil

提供KunlunSwift SDK相关的工具方法。

#### 静态方法

##### isKunlunSwiftAvailable()

检查KunlunSwift SDK是否可用。

**返回值:** boolean

##### initKunlunSwift(Context context)

初始化KunlunSwift SDK（如果可用）。

**参数:**
- `context`: 上下文

**返回值:** boolean - 初始化是否成功

## 错误码

| 错误码 | 说明 |
|--------|------|
| 1001 | 网络连接失败 |
| 1002 | 服务器响应错误 |
| 1003 | 参数配置错误 |
| 1004 | 问卷数据解析失败 |
| 1005 | 用户权限不足 |
| 1006 | SDK未初始化 |
| 1007 | Flutter引擎启动失败 |

## 数据格式

### 问卷结果数据格式

```json
{
  "questionnaireId": "questionnaire456",
  "userId": "user123",
  "submitTime": "2024-01-01T12:00:00Z",
  "answers": [
    {
      "questionId": "q1",
      "questionType": "single_choice",
      "answer": "option_a"
    },
    {
      "questionId": "q2",
      "questionType": "multiple_choice",
      "answer": ["option_b", "option_c"]
    },
    {
      "questionId": "q3",
      "questionType": "text",
      "answer": "用户输入的文本内容"
    }
  ],
  "duration": 120,
  "score": 85
}
```

### 错误信息格式

```json
{
  "errorCode": 1001,
  "errorMessage": "网络连接失败",
  "timestamp": "2024-01-01T12:00:00Z"
}
```

## 最佳实践

### 1. 生命周期管理

```java
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // 设置监听器
        QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
            @Override
            public void onSuccess(String result) {
                // 处理结果
            }
            
            @Override
            public void onError(String error) {
                // 处理错误
            }
            
            @Override
            public void onCancel() {
                // 处理取消
            }
        });
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 清理监听器
        QuestionnairSdk.setResultListener(null);
    }
}
```

### 2. 错误处理

```java
QuestionnairSdk.setResultListener(new QuestionnairSdk.ResultListener() {
    @Override
    public void onError(String error) {
        try {
            JSONObject errorObj = new JSONObject(error);
            int errorCode = errorObj.getInt("errorCode");
            String errorMessage = errorObj.getString("errorMessage");
            
            switch (errorCode) {
                case 1001:
                    // 处理网络错误
                    showNetworkErrorDialog();
                    break;
                case 1003:
                    // 处理配置错误
                    showConfigErrorDialog();
                    break;
                default:
                    // 处理其他错误
                    showGenericErrorDialog(errorMessage);
                    break;
            }
        } catch (JSONException e) {
            // 处理JSON解析错误
            showGenericErrorDialog(error);
        }
    }
});
```

### 3. 配置验证

```java
public boolean validateConfig(QuestionnairConfig config) {
    if (TextUtils.isEmpty(config.getUserId())) {
        Log.e("Questionnaire", "User ID is required");
        return false;
    }
    
    if (TextUtils.isEmpty(config.getQuestionnaireId())) {
        Log.e("Questionnaire", "Questionnaire ID is required");
        return false;
    }
    
    if (TextUtils.isEmpty(config.getServerUrl())) {
        Log.e("Questionnaire", "Server URL is required");
        return false;
    }
    
    return true;
}
```