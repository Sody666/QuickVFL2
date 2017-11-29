# QuickVFL2
Yet another layout framework to replace xib

## QuickVFL2简介
简单粗暴地说，QuickVFL诞生的目的就是要帮助你把应用里绝大部分的布局代码干掉。你只要给它提供一个布局配置，它就会帮你把剩余的工作做掉。 

### 特点
- 在配置文件里完成视图结构构建
- 在配置文件里完成初步的控件设置
- 只需要在源代码里加几行代码就可以完成所有布局工作
- 配合服务端下发布局文件，可以轻松实现动态布局

### 安装办法
1. 从Released lib中下载发布出来的framework，并把它放到你项目里
2. 在Target->Build Settings->Other Linker Flags添加上**-ObjC**
3. 在需要用QuickVFL的地方#import < QuickVFL/QuickVFL.h >既可
### 其他数据
指标 | 数值
---|---
语言 | object-c
版本 | 2.0
支持系统版本 | >=8.0

### 调试办法
QuickVFL暴露出了一个标记为
```
extern BOOL enableVFLDebug;
```
只要你在适合的地方，比如AppDelegate里，用适当的方式开启这个标记为，则会给你的调试工作带来很大的便利。

比如，用以下方式开启：
```
#ifdef DEBUG
    enableVFLDebug = YES;
#else
    enableVFLDebug = NO;
#endif
```
不过请注意，尽量不要在生产环境里开启这个比较位，因为会有很多调试信息会被写到约束里，带来一些成本。
#### 具体的例子
比如，在约束冲突了之后，终端里有以下警告：
```
2017-11-29 15:20:16.961 QuickVFLUseLib[82431:6788440] Unable to simultaneously satisfy constraints.
  Probably at least one of the constraints in the following list is one you don't want. 
  Try this: 
    (1) look at each constraint and try to figure out which you don't expect; 
    (2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "label1_ Top Equal wrapper1 Top. VFL: V:|-(8)-[label1_]-(8)-|",
    "wrapper1 Bottom Equal label1_ Bottom. VFL: V:|-(8)-[label1_]-(8)-|",
    "HidingView Height Equal HidingView NotAnAttribute. VFL: (null)"
)

Will attempt to recover by breaking constraint 
wrapper1 Bottom Equal label1_ Bottom. VFL: V:|-(8)-[label1_]-(8)-|

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKit/UIView.h> may also be helpful.
```
一共有三个约束发生了冲突：
1. VFL里名字为label1_的控件，其到容器的顶部发生了冲突。结合VFL，可以锁定为“V:|-(8)-”
2. VFL里名字为label1_的控件，其到容器的底部发生了冲突。结合VFL，可以锁定为“-(8)-|”
3. 某个非VFL添加的约束，限定自身高度为某个数值的约束发生了冲突。
综合起来，应该可以推断出，label1_把其容器撑起来，使得其容器的高度至少为16.但后来隐藏约束应该是要限定其容器高度为0，因而两者有了冲突。

再从最后的结果来看，系统是打破掉了label1_到底部的约束，从而解决了问题。

## QuickVFL2工作流程
![处理流程](https://github.com/Sody666/QuickVFL2/blob/master/WikiResources/handleFlow.png)

## QuickVFL2组件构成
典型的结构是一个描述视图结构和属性的json文件，然后在oc代码（常常是View Controller或者View）里使用API加载结构文件。
例如，一个只有一个UITableView的VC，它的描述文件只是：
```
{
  "tableContent":"UITableView",
  ":layout":"H:|[tableContent]|;V:|[tableContent]|;"
}
```
它描述了当前VC的View根下只有一个UITableView，然后垂直和水平方向上紧贴容器。

然后，你在VC里要做的工作无非就是声明tableContent的属性，和直接在某个地方加载结构文件：

```
@interface MyViewController()
@property (nonatomatic, weak) UITableView* tableContent;
// ...
@end

// 常常是在ViewDidLoaded里
[QLayoutManager layoutForFileName:@"MyViewController.json"
                         entrance:self.view
                           holder:self];
```
然后，布局工作就完成了。QuickVFL会自动帮你把结构文件读进来，然后按结构创建相关视图，然后设置属性和约束，最后还帮你按照名字映射到你的VC里。

如果要深入了解，可以点击查看[怎么简单写一个布局文件](https://github.com/Sody666/QuickVFL2/wiki/%E4%BB%8E%E7%AE%80%E5%8D%95%E5%BC%80%E5%A7%8B%EF%BC%8C%E9%80%90%E6%AD%A5%E6%8E%8C%E6%8F%A1QuickVFL%E7%9A%84%E5%B8%83%E5%B1%80%E6%96%87%E4%BB%B6%E4%B9%A6%E5%86%99)

### 结构文件的结构
可以这样描述结构文件的结构：
```
{
	NODE
}
```
然后NODE可以是一个容器（UIView），也可能是一个实实在在的控件。当一个UIView下包含有其他的的控件的时候，它就是容器了。然后一个NODE的典型结构是这样的：
```
"NameOfWidget1":"WidgetName",
"labelTitle":"UILabel",
"buttonSubmit":"UIButton",


":optionName":"OptionValue",
":scrollV":"myScrollView"
```
所以，NODE的里就充斥了一个个的键值对。所有的键里，只有两大类。一种是以冒号打头的选项（option）键，另一种则是控件的名称。
#### 控件名称的特点
- 匿名控件－以“_”结尾的名称。匿名控件要不是你压根不想在代码里看到的视图容器，要不就是你觉得没必要在VC里特意声明的控件。比如，一个按钮，你只要在布局的时候拿到它，设置完标题和其他属性后，就再也没必要看到它了。
- 非匿名的控件，也就是名称不以“_”结尾的的控件，会在映射的时候做强制验证。当它在holder里找不到声明的时候，会以异常的方式立即告诉你。
#### 控件值的特点
一个普通的控件，如果没啥好声明的，它的值就是它的类名。比如例子中的
```
"labelTitle":"UILabel"
```
当你要给他添加更多的选项的时候，你则需要用字典的方式给它设值。比如上面的例子：
```
"labelTitle":{
	":className":"UILabel",
	":widthEqual":"anotherView"
}
```
请注意哦，此时字典里只能有选项的键值对。
当然，以下两种方式是等效的：
```
"labelTitle":{
	":className":"UILabel",
}
```
```
"labelTitle":"UILabel"
```
#### 控件类名的说明
每一个视图都必须有一个明确的类名，否则在创建视图的时候会报错。但容器视图可以不用声明类名，因为当某个NODE它是视图容器的时候——也就是它底下的键值对包含有控件的声明，它的默认类名就是UIView。然后声明的类必须是holder里声明的一致的类或子类。举例而言，你在结构文件里说某某是一个UILabel，你在holder里可以把它声明为UIView。当这关系不匹配的时候，布局的时候会直接抛异常提醒你去修改。
#### 选项
控件的选项是QuickVFL很重要的组成部分。内容有点多，请移步[这里](https://github.com/Sody666/QuickVFL2/wiki/QuickVFL-%E6%8E%A7%E4%BB%B6%E5%B1%9E%E6%80%A7)查看

### 常用API
QuickVFL2已经大规模减少了必须要掌握的API数目，目的是提高其易用性和自动化程度。
#### QLayoutManager
布局工具
```
/**
 *	使用布局文件进行布局
 *
 *  @param fileName 布局的文件名
 *  @param entrance	视图的入口 比如，VC的view属性。创建的所有视图将会挂载在它下面
 *  @param holder	对视图进行映射的对象。一般情况下是视图入口的拥有者
 *
 *  @return 返回布局的结果，包括创建的视图和视图数据
 **/
+(QLayoutResult*) layoutForFileName:(NSString*)fileName
                           entrance:(UIView*)entrance
                             holder:(id)holder;
```

#### QLayoutResult
布局结果
```
/**
 *  使用名字获得视图
 **/
-(id)viewNamed:(NSString*)name;

/**
 *  使用名字获得视图数据
 **/
-(id)dataForViewNamed:(NSString*)name;
```

#### UIScrollView(constraint)
滚动视图
```
/**
 *  刷新滚动视图的内容
 *  务必此滚动视图在此之前掉用q_prepareContentViewForOrientation:准备好一切。
 */
-(void)q_refreshContentView;
```
#### UIView(constraint)
在指定方向上展示、隐藏视图
```
/**
 *  控制视图的可视性
 *
 *  @param visible   是否展示
 *  @param vertically 水平还是垂直方向
 */
-(void)q_setVisibility:(BOOL)visible isVertically:(BOOL)vertically;

/**
 *  获取视图的可视性
 *
 *  @param vertically 水平还是垂直方向
 */
-(BOOL)q_visibleVertically:(BOOL)vertically;
```

#### 使用例子
- [使用ScrollView包含视图的内容](https://github.com/Sody666/QuickVFL2/wiki/QuickVFL-%E6%A1%86%E6%9E%B6DEMO%EF%BC%9A%E4%BD%BF%E7%94%A8ScrollView%E5%8C%85%E5%90%AB%E8%A7%86%E5%9B%BE%E7%9A%84%E5%86%85%E5%AE%B9)
- [隐藏／展示View](https://github.com/Sody666/QuickVFL2/wiki/QuickVFL-%E6%A1%86%E6%9E%B6DEMO%EF%BC%9A%E9%9A%90%E8%97%8F%EF%BC%8F%E5%B1%95%E7%A4%BAView)

#### 更多资料

- [学习VFL](https://github.com/Sody666/QuickVFL2/wiki/%E5%AD%A6%E4%B9%A0VFL)
