//
//  EmojiKeyBoardView.h
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/2/28.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiKeyBoardViewDelegate <NSObject>

/* 点击某个表情，将会显示在输入框内 */
- (void)showEmoji:(NSString *)emojiStr;
/* 点击“删除”按钮 */
- (void)emojiViewDelete;

/* 点击“发送”按钮 */
- (void)emojiViewSend;

@end

@interface EmojiKeyBoardView : UIView

+ (instancetype)keyboard;

- (void)loadEmojiKeyBoard:(BOOL)isShow;

- (instancetype)initWithDelegate:(id<EmojiKeyBoardViewDelegate>)delegate;



@property (strong, nonatomic) id<UITextInput> textView;

@property (nonatomic, strong) UICollectionView *emojiCollectionView;

@property (nonatomic, strong) UIPageControl *emojiPageControl;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) id<EmojiKeyBoardViewDelegate> emojiDelegate;

@property (nonatomic, assign) BOOL emojiKeyBoardShow;

@end
