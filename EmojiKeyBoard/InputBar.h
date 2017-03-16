//
//  InputBar.h
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/3/1.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"
#import "EmojiKeyBoardView.h"
@protocol InPutBarDelegate <NSObject>
@optional
// 当键盘位置发生变化是调用，durtaion时长
- (void)keyBoardView:(CGRect)endR ChangeDuration:(CGFloat)durtion EmojikeyBoardType:(BOOL)type;

// 发送事件 文字，图片都有可能
//- (void)showEmoji:(NSString *)emojiStr;

//删除按钮
- (void)emojiViewDelete;

//// 音频事件
//- (void)keyBoardView:(EmojiKeyBoardView *)keyBoard audioRuning:(UILongPressGestureRecognizer *)longPress;
@end

@interface InputBar : UIView
@property (nonatomic,strong) UIView *topView;

@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@property (assign, nonatomic) BOOL fitWhenKeyboardShowOrHide;

@property (nonatomic, assign) BOOL isDefaultKeyboard;


@property (nonatomic, assign) id<InPutBarDelegate> delegate;

- (void)setFitWhenKeyboardShowOrHide:(BOOL)fitWhenKeyboardShowOrHide;

@end
