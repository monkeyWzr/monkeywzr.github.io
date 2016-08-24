---
layout: post
title: C#学习笔记
category: 学习笔记
tags: [c#,教程]
keywords: 
description: 
---

这里记录的都是与c/c++不太一样的地方，

## 数据类型

### 值类型

从类System.ValueType中派生，比较独特的有`decimal``sbyte`;
C#提供了内置类型转换的方法，例如`ToBoolean``ToInt32``ToString`等等。

### 可空类型(Nullable)

这个单独列出来了因为很有趣，他是允许值为正常类型范围内或者是null。

		//语法
		<date_type> ? <variable_name> = null;
		int? num1 = null;
		int? num2 = 250;

Null合并运算符`??`用于定义可空类型和引用类型的默认值；如果第一个操作数的侍卫null则返回第二个操作数，否则返回第一个操作数的值。

		//继续使用上面的num1和num2
		int num3;
		num3 = num1 ?? 10;//num3 = 10;
		num3 = num2 ?? 38;//num3 = 250;

### 引用类型

引用类型不包含储存在变量中的实际数据。内置的引用类型有`object``dynamic``string`

1. 对象(object)类型
object类型是c#通用类型系统CTS中所有数据的终极基类，可以分配任何类型的值。一个值类型转换为对象类型时称为__装箱__，反过来称为__拆箱__;

		object obj；
		obj = 100;//装箱

2. 动态(Dynamic)类型
类型检查在运行时发生。

		dynamic a = 20;

3. 字符串(String)类型
`String`是System.String类的别名，从对象类派生。有一个`@`分配方式（称作逐字字符串）。

		String str1 = "Hello world";
		String str2 = @"C:\Windows";//转义字符会当作普通字符看待

`@`字符串中所有的换行符缩进符等都计算在字符串长度内。


### 指针类型

与c/c/c++有相同的类型；

		type* identifier;


## 参数传递

C#中有三种参数传递方式：值参数、引用参数、输出参数。

引用参数：使用`ref`关键字声明引用参数。

		public void swap(ref int x, ref int y)
		{
			//...
		}

输出参数：这个比较特殊，可以使用这个来从函数中返回多个值，而return只能返回一个值。
这个需要一个实例来说明：

		using System;

		namespace test
		{
			class NumberTest
			{
				public void getValue(out int a,out int b)
				{
					int temp = 10;
					a = temp;
					b = temp*2;
				}

				static void Main(string[] args)
				{
					NumberTest n = new NummbrTest();
					int m,n;
					n.getValue(out m,out n);
					Console.WriteLine(m);
					Console.WriteLine(n);
					Console.Readkey();
				}
			}
		}


## 数组

### 基础知识

数组也是引用类型，使用new来创建数组。

		double[] arr1 = new double[10];
		double[] arr2 = new double[] {1,2,3,4,5};
		double[] arr3 = arr2;//这时arr3与arr2指向相同的内存位置。

可以使用foreach循环来遍历数组元素。

		foreach(double i in arr2)
		{
			//...
		}

### 交错数组

说白了就是数组的数组。与多维数组的区别在于它是不规则的（不知道可不可以这么说）。

		int[][] marr = new int [2][] {new int{1,2,3},new int{4,5,6,7,8}};

### 参数数组

如果声明一个方法时不能确定需要传递多少个参数，参数数组就派上了用场。
使用数组作为形参时，C#提供了params关键字，使调用数组为形参的方法时既可以传递数组实参也可以直接出传递一组数组。
实例：

		//声明
		public int forAverage(params int[] arr)
		{
			//...
		}

		//调用
		object.forAverage(1,2,3,4,5);//也可传递一数组名

### 动态数组

动态数组基本上可以替代一个数组。但是动态数组允许使用索引在指定的位置添加和移除项目，动态数组会自动调整大小。也允许在内存中进行动态内存分配、增加、搜索、排序各项。
常用属性：

>Capacity - 获取或设置ArrayList可以包含的元素个数。
>count - 获取ArrayList中实际包含的元素个数
>item - 获取或设置指定索引处的元素

常用方法：

>public virtual int Add(object value); 在ArrayList的末尾添加一个对象
>public virtual void Insert(int index,object value); 在指定索引处插入一个元素
>public virtual void Clear(); 移除所有元素


## 特性(Attribute)

...

## 反射(Reflection)

...

## 属性(Property)

属性是类、结构和接口的命名成员。类或者结构中的成员变量或者方法称为域(Field)，而属性是域的扩展，使用访问器来读写和操作私有域。抽象域也可以有抽象属性。这些属性应该在派生类中被实现。

		private string code="foobar";

		public string Code
		{
			get
			{
				return code;
			}
			set
			{
				code = value;
			}
		}


## 索引器(Indexer)

...

## 委托(Delegate)

...

## 事件

...

## 集合

...

## 多线程

...


		


