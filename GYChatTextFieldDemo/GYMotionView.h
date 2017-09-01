//
//  MotionView.h
//  eCloud
//
//  Created by lidianchao on 2017/7/28.
//  Copyright © 2017年 网信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYScreen.h"
typedef void(^ChooseMotionCallback)(UIView *motion,NSArray *phArr,NSArray *bqArr);
@interface GYMotionView : UIView

/** 选择表情回调 */
@property(nonatomic, copy) ChooseMotionCallback chooseMotionCallback;
/** 发送回调 */
@property(nonatomic, copy) void(^sendMessageCallback)();
@end
