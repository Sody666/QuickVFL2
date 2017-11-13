# QuickVFL2
Yet another layout framework to replace xib

## QuickVFL2简介
QuickVFL是一个面向cocoa touch的布局框架。它希望能提供一个可视性好、团队并行合作度高的工具。希望能在xib布局和其他的第三方布局框架外，给你提供的另外一个选择。掌握了VFL之后，你回发现QuickVFL上手非常的容易。在实际工作中，可极大地降低布局的工作量和相关文件的维护量。

### 特点
凡是苹果VFL的特征，QuickVFL一律支持。除此以外，它还有以下的增强点
- 支持多行描述
- 支持对齐
- 支持设置比例约束
- 支持scrollView自包围
- 支持结构化视图

### 安装办法
1. 从Released lib中下载发布出来的framework，并把它放到你项目里
2. 在Target->Build Settings->Other Linker Flags添加上**-ObjC**
3. 在需要用QuickVFL的地方#import < QuickVFL/QuickVFL.h >既可

## QuickVFL2文件结构
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
