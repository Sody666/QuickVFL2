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
