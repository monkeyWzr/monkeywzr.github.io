---
title: 提升ListView的效率
date: 2017-10-04 04:52:18
category: tech
tags:
    - android
    - java
keywords:
    - android
    - java
    - ListView
---

## 利用好getView中的convertView参数

`getView()`方法中有一个`convertView`参数用来缓存已经加载好的布局，从而我们可以在代码中对布局进行重用：

```java
public View getView(int position, View convertView, ViewGroup parent) {
    View view = convertView;
    if (view == null)
        view = LayoutInflater.from(getContext()).inflate(resorceId, parent, false);

    // ...
}
```

## 使用ViewHolder

定义`ViewHolder`来存储已经获取的`Views`实例。

```java
class ViewHolder {
    TextView textView;
    ImageView imageView;
    // ...
}
public View getView(int position, View convertView, ViewGroup parent) {
    View view = convertView;
    VIewHolder holder;
    if (view == null) {
        view = LayoutInflater.from(getContext()).inflate(resorceId, parent, false);
        holder = new ViewHolder();
        // save views to the holder.

        view.setTag(holder);
    } else {
        viewHolder = view.getTag();
    }

    // ...
}

```

## 使用后台线程

Using a background thread ("worker thread") removes strain from the main thread so it can focus on drawing the UI. In many cases, using AsyncTask provides a simple way to perform your work outside the main thread. AsyncTask automatically queues up all the execute() requests and performs them serially. This behavior is global to a particular process and means you don’t need to worry about creating your own thread pool.

In the sample code below, an AsyncTask is used to load images in a background thread, then apply them to the UI once finished. It also shows a progress spinner in place of the images while they are loading.

```java
// Using an AsyncTask to load the slow images in a background thread
new AsyncTask<ViewHolder, Void, Bitmap>() {
    private ViewHolder v;

    @Override
    protected Bitmap doInBackground(ViewHolder... params) {
        v = params[0];
        return mFakeImageLoader.getImage();
    }

    @Override
    protected void onPostExecute(Bitmap result) {
        super.onPostExecute(result);
        if (v.position == position) {
            // If this item hasn't been recycled already, hide the
            // progress and set and show the image
            v.progress.setVisibility(View.GONE);
            v.icon.setVisibility(View.VISIBLE);
            v.icon.setImageBitmap(result);
        }
    }
}.execute(holder);
```

Beginning with Android 3.0 (API level 11), an extra feature is available in AsyncTask so you can enable it to run across multiple processor cores. Instead of calling execute() you can specify executeOnExecutor() and multiple requests can be executed at the same time depending on the number of cores available
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg1MTEzMjI0LDE1Njc2NTExMV19
-->