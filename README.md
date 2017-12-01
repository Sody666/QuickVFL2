# QuickVFL2
Yet another layout framework to replace xib

## QuickVFL2简介
简单粗暴地说，QuickVFL诞生的目的就是要帮助你把应用里绝大部分的布局代码干掉。你只要给它提供一个布局配置，它就会帮你把剩余的工作做掉。 

### 特点
- 在配置文件里完成视图结构构建
- 在配置文件里完成初步的控件设置
- 只需要在源代码里加几行代码就可以完成所有布局工作
- 配合服务端下发布局文件，可以轻松实现动态布局

***
### 基本信息
指标 | 数值
---|---
语言 | object-c
版本 | 2.2
支持系统版本 | >=8.0

***

### 最新修改
- VFL里添加命名约束功能
- 增强约束调试功能

***

### 性能
我们使用xib和QuickVFL去实现同一个控件，然后反复创建此控件并完全展开1000次，然后抓取到如下时间数据：

指标 | 数值(秒)
---|---
XIB时间 | 13.95
Q时间 | 10.66

注意：
- 每个测试运行完以后，程序重启以免相互影响。

从数值上看，QuickVFL比XIB的方式大约快了1/4。
[点这里查看进行比较代码](https://github.com/Sody666/QuickVFL2/blob/master/Project/QuickVFL2/ViewControllers/PerformanceViewController.m)

另外，在QuickVFL工作过程中，布局工作占用的时间分布为（1000次累计的数值）：

指标 | 数值(秒) | 占比(%)
---|---|---
总共 | 1.90 | 100
解析配置文件 | 0.35 | 18.2
创建视图 | 0.38 | 20.2
创建约束 | 0.90 | 47.3
设置控件内容 | 0.08 | 4.4
映射变量 | 0.16 | 8.6
处理结果 | 0.02 | 1.1

从数值可以看出，整个过程中主要时间还是花在视图的LayoutIfNeeded的操作上。
***
### 安装办法
1. 从[Released lib](https://github.com/Sody666/QuickVFL2/tree/master/ReleasedLibs)中下载发布出来的framework，并把它放到你项目里
2. 在Target->Build Settings->Other Linker Flags添加上**-ObjC**
3. 在需要用QuickVFL的地方#import < QuickVFL/QuickVFL.h >既可


### 调试办法
#### 设置运行模式
QuickVFL一共支持以下的模式：
- QLayoutModeVerbose：打印所有信息，并且当有任何错误时，即刻抛异常告知。
- QLayoutModeQuiet：悄悄干活，不提供任何调试信息。但有任何错误时，即刻抛异常告知
- QLayoutModePeaceful：平安模式。有错就悄悄跳过。一般是生产环境用。


只要你在适合的地方，比如AppDelegate里，设置适当的模式即可。

比如，用以下方式开启：
```
#ifdef DEBUG
    [QLayoutManager setupLayoutMode: QLayoutModeVerbose];
#else
    // 如果你想在布局走歪的时候停掉应用
    // [QLayoutManager setupLayoutMode: QLayoutModeQuiet];
    // 如果你想一条道走到黑
    [QLayoutManager setupLayoutMode: QLayoutModePeaceful];
#endif
```
不过请注意，尽量不要在生产环境里开启Verbose模式，因为会有很多调试信息会被写到约束里，带来一些成本。
#### 约束冲突分析
[约束冲突的分析与解决实例](https://github.com/Sody666/QuickVFL2/wiki/%E7%BA%A6%E6%9D%9F%E5%86%B2%E7%AA%81%E5%88%86%E6%9E%90%E5%AE%9E%E4%BE%8B)

***

### 使用QuickVFL
QuickVFL的上手是非常容易的。只要你掌握以下2技能即可
#### 书写配置文件
可以通过如下WiKi文章掌握：
1. [分两步有条不紊地完成布局配置文件](https://github.com/Sody666/QuickVFL2/wiki/%E5%88%86%E4%B8%A4%E6%AD%A5%E6%9C%89%E6%9D%A1%E4%B8%8D%E7%B4%8A%E5%9C%B0%E5%AE%8C%E6%88%90%E5%B8%83%E5%B1%80%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)
2. [从简单开始，逐步掌握QuickVFL的布局文件书写](https://github.com/Sody666/QuickVFL2/wiki/%E4%BB%8E%E7%AE%80%E5%8D%95%E5%BC%80%E5%A7%8B%EF%BC%8C%E9%80%90%E6%AD%A5%E6%8E%8C%E6%8F%A1QuickVFL%E7%9A%84%E5%B8%83%E5%B1%80%E6%96%87%E4%BB%B6%E4%B9%A6%E5%86%99)

#### 调用API加载配置文件
使用QLayoutManager的接口
```
/**
 *  使用布局文件进行布局
 *
 *  @param fileName 布局的文件名
 *  @param entrance 视图的入口 比如，VC的view属性。创建的所有视图将会挂载在它下面
 *  @param holder 对视图进行映射的对象。一般情况下是视图入口的拥有者
 *
 *  @return 返回布局的结果，包括创建的视图和视图数据
 **/
+(QLayoutResult*) layoutForFileName:(NSString*)fileName
                           entrance:(UIView*)entrance
                             holder:(id)holder;
```

比如例子：
```
@implementation StayShapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [QLayoutManager layoutForFileName:@"StayShapeViewController.json"
                             entrance:self.view
                               holder:self];
}

@end
```
StayShapeViewController.json就是布局文件在沙盒里的名称。

***

### 结构文件的结构
[布局配置文件结构说明](https://github.com/Sody666/QuickVFL2/wiki/%E5%B8%83%E5%B1%80%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84%E8%AF%B4%E6%98%8E)

### 更多有用的API
[常用API](https://github.com/Sody666/QuickVFL2/wiki/%E5%B8%B8%E7%94%A8API)

### 使用例子
- [使用ScrollView包含视图的内容](https://github.com/Sody666/QuickVFL2/wiki/QuickVFL-%E6%A1%86%E6%9E%B6DEMO%EF%BC%9A%E4%BD%BF%E7%94%A8ScrollView%E5%8C%85%E5%90%AB%E8%A7%86%E5%9B%BE%E7%9A%84%E5%86%85%E5%AE%B9)
- [隐藏／展示View](https://github.com/Sody666/QuickVFL2/wiki/QuickVFL-%E6%A1%86%E6%9E%B6DEMO%EF%BC%9A%E9%9A%90%E8%97%8F%EF%BC%8F%E5%B1%95%E7%A4%BAView)

### 更多资料
- [学习VFL](https://github.com/Sody666/QuickVFL2/wiki/%E5%AD%A6%E4%B9%A0VFL)
- [怎么简单写一个布局文件](https://github.com/Sody666/QuickVFL2/wiki/%E4%BB%8E%E7%AE%80%E5%8D%95%E5%BC%80%E5%A7%8B%EF%BC%8C%E9%80%90%E6%AD%A5%E6%8E%8C%E6%8F%A1QuickVFL%E7%9A%84%E5%B8%83%E5%B1%80%E6%96%87%E4%BB%B6%E4%B9%A6%E5%86%99)
- QuickVFL2工作流程

![处理流程](https://github.com/Sody666/QuickVFL2/blob/master/WikiResources/handleFlow.png)
