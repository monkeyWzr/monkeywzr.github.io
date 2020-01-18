---
title: 使用Gson解析含有动态未知键名的json数据
date: 2017-09-05 14:16:06
category: tech
tags:
    - android
    - java
keywords:
    - android
    - java
    - gson
    - json
    - 动态字段
    - 未知字段
---

初学Android开发，最近在开发一个用来练手的android小项目，遇到了一个问题：在解析json时遇到了含有未知字段的json数据，此时不能通过Gson库的静态解析方式进行解析。文档上提到了可以自定义解析器，网上也有一些类似的实现案例。我也记录下相应的解决方案。

我获取的json数据可简化为：

```json
// news
{
    news_id: "id",
    news_title: "title"
}
```

```json
// monthJson
{
    "2017-09-05": [
        {
            news_id: "id1",
            news_title: "title1"
        },
        {
            news_id: "id2",
            news_title: "title2"
        }
    ],
    "2017-09-04": [
        {
            news_id: "id1",
            news_title: "title1"
        },
        {
            news_id: "id2",
            news_title: "title2"
        }
    ]
}
```

可建立如下模型（省略 getter 和 setter ）：

```java
public class News {
    @SerializedName("news_id")
    private String id;
    @SerializedName("news_title")
    private String title;
}

public class MonthNews {
    private Map<String, List<News>> monthNews;

    public MonthNews(Map<String, List<News>> monthNews) {
        this.monthNews = monthNews;
    }

    public Map<String, List<News>> getMonthNews() {
        return monthNews;
    }
}
```

通过注册自定义的解析器进行解析：
```java
JSONObject jsonObject = new JSONObject(monthJson);
Gson gson = new Gson();
GsonBuilder builder = new GsonBuilder();
builder.registerTypeAdapter(MonthNews.class, new JsonDeserializer<MonthNews>() {
    @Override
    public MonthNews deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        JsonObject jsonObject = json.getAsJsonObject();
        Map<String, List<News>> month = new LinkedHashTreeMap<>();
        for (Map.Entry<String, JsonElement> entry : jsonObject.entrySet()) {
            List<News> day = context.deserialize(entry.getValue(), new TypeToken<List<News>>(){}.getType());
            month.put(entry.getKey(), day);
        }
        return new MonthNews(monthNews);
    }
});
gson = builder.setFieldNamingPolicy(LOWER_CASE_WITH_UNDERSCORES).create();
MonthNews monthNews = gson.fromJson(jsonObject.toString(), MonthNews.class);
```

其实我觉得在这个场景下，不使用gson的自定义解析器而直接通过JSONObject进行解析显得更方便：
```java
JSONObject jsonObject = new JSONObject(monthJson);
Gson gson = new Gson();
Map<String, List<News>> month = new LinkedHashTreeMap<>();
JSONArray names = jsonObject.names();
for (int i = 0; i < names.length(); i++) {
    String day = jsonObject.getString(names.getString(i));
    news = gson.fromJson(day, new TypeToken<List<News>>(){}.getType());
    month.put(names.getString(i), news);
}
MonthNews monthNews = new MonthNews(month);
```

两种方式归根到底都是通过Map得到了变化的key， 效率方面应该没有什么明显区别。

>__参考链接__
>[GitHub: Gson](https://github.com/google/gson/blob/master/UserGuide.md#custom-serialization-and-deserialization)
>[Dealing with randomly generated and inconsistent JSON field/key names using GSON](https://stackoverflow.com/questions/6455303/dealing-with-randomly-generated-and-inconsistent-json-field-key-names-using-gson/6460364#6460364)
>[How to decode JSON with unknown field using Gson?](https://stackoverflow.com/questions/20442265/how-to-decode-json-with-unknown-field-using-gson)
>[Gson解析JSON中动态未知字段key的方法](http://blog.csdn.net/Chaosminds/article/details/49049455)
