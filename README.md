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
### /** 长按发送文件 */ #
- (void)longPressSendFile:(NSString *)fileName;
### /** 发送回调 */ #
- (void)sendMessage:(NSString *)msg;
### /** 弹起键盘回调 */ #
- (void)keyboardShown:(CGSize)keyboardSize;
### /** 点击键盘上@按钮键时回调 */ #
- (void)clickedAt:(NSString *)msg;
### /** 收起键盘回调 */ #
- (void)keyboradHidden;
### /** 语音输入按钮事件 */ #
- (void)recordTouchUpInside:(id)sender;
- (void)recordTouchUpOutside:(id)sender;
- (void)recordTouchDown:(id)sender;
- (void)recordTouchDragOutside:(id)sender;
- (void)recordTouchDragIn:(id)sender; 
## 2、主要接口
