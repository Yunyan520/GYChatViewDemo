# GYChatViewDemo
# iOS项目基本框架
## 1、iOS仿微信聊天输入框封装搭建
## 2、简易MVC框架
## 3、方法扩展，接口暴露，便于调用
# 代码分析---接口展示
## 所有功能的实现方法集中在GYChatManager管理类中
## 1、代理方法

### /** 点击功能按钮回调 */ #
- (void)functionClicked:(UIView *)functionItem;
### - (void)longPressSendFile:(NSString *)fileName;
### - (void)sendMessage:(NSString *)msg;
### - (void)keyboardShown:(CGSize)keyboardSize;
### - (void)clickedAt:(NSString *)msg;
### - (void)keyboradHidden;
### - (void)recordTouchUpInside:(id)sender;
### - (void)recordTouchUpOutside:(id)sender;
### - (void)recordTouchDown:(id)sender;
### - (void)recordTouchDragOutside:(id)sender;
### - (void)recordTouchDragIn:(id)sender;
## 2、主要接口
