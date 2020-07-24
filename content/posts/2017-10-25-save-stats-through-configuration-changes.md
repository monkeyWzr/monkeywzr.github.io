---
title: Android配置变更时的状态保留
date: 2017-10-25 03:59:14
categories: tech
tags:
    - android
    - Java
keywords:
    - android
    - java
    - configuration
    - status
---

在设备配置变化时，Android会销毁并重建正在运行的 `Activity`， 通常使用 `onSaveInstanceState()`，来保存有关应用状态的数据。 然后，可以在 `onCreate()` 或 `onRestoreInstanceState()` 期间恢复 `Activity` 状态。

但是，在有些情况下，如在执行一段耗时的异步网络请求，`onSaveInstanceState()`就显得力不从心了，只能重新执行异步操作。这样不但影响用户体验，处理不慎还可能会使应用异常终止。

文档中推荐使用 `Fragment` 来保留有状态对象的引用。通过 `setRetainInstance(true)` 方法，系统不会在重启活动时销毁fragment。

```java
public class RetainedFragment extends Fragment {

    // data object we want to retain
    private MyDataObject data;

    // this method is only called once for this fragment
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // retain this fragment
        setRetainInstance(true);
    }

    public void setData(MyDataObject data) {
        this.data = data;
    }

    public MyDataObject getData() {
        return data;
    }
}
```

在添加fragment时定义一个标签以便恢复。

```java
public class MyActivity extends Activity {

    private RetainedFragment dataFragment;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // find the retained fragment on activity restarts
        FragmentManager fm = getFragmentManager();
        dataFragment = (DataFragment) fm.findFragmentByTag(“data”);

        // create the fragment and data the first time
        if (dataFragment == null) {
            // add the fragment
            dataFragment = new DataFragment();
            fm.beginTransaction().add(dataFragment, “data”).commit();
            // load the data from the web
            dataFragment.setData(loadMyData());
        }

        // the data is available in dataFragment.getData()
        ...
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // store the data in the fragment
        dataFragment.setData(collectMyLoadedData());
    }
}
```

另外，也可在清单文件中配置活动的`android:configChanges`属性阻止系统重启活动，但是并不推荐这种办法。

>相关链接
>[官方文档](https://developer.android.com/guide/topics/resources/runtime-changes.html)
>[Android 转屏那些事儿](http://www.gongmingqm10.net/blog/2015/12/16/you-should-know-about-android-rotate/)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk0MjcxNDU4MywtMjAxOTI0NjUwNF19
-->