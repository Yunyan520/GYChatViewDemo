# GYChatViewDemo
## 所有功能的实现方法集中在GYChatManager管理类中
# iOS项目基本框架
## 1、iOS仿微信聊天输入框封装搭建
## 2、简易MVC框架
## 3、方法扩展，接口暴露，便于调用
# 代码分析---接口展示
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
### 创建框架UI #
- (void)configChatRootView:(GYConfigChatViewItem *)item;
###  创建语音输入提示UI #
- (void)configVoiceInputPromtUI:(UIView *)superView callback:(ConfigViewCallback)callback;
### 创建功能UI #
- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
### 更改提示状态 #
- (void)InputPromptViewStatus:(PromptStatus)status;
### 创建表情UI #
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
### 是否收起键盘 #
- (void)keyboardIsShow:(BOOL)isShow;
### 对某条消息定向回复 #
- (void)orientateAnswer:(NSString *)messageAnswered userName:(NSString *)userName;
### 艾特某人 #
- (void)atSomeone:(NSString *)personName isLongPressed:(BOOL)isLongPressed;
### 获取当前textView内内容 #
- (NSString *)getCurrentTextViewMessage;
### 添加草稿 #
- (void)addDraft:(NSString *)draft;
