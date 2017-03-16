//
//  InputBar.m
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/3/1.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "InputBar.h"
#import "Masonry.h"
#import "UIView+Positioning.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface InputBar ()<UITextViewDelegate>

@property (nonatomic, strong) NSArray *emojiButtonImageArray;

@property (nonatomic, assign) BOOL isRegistedKeyboardNotif;


@end

@implementation InputBar

- (void)dealloc{
    if (_isRegistedKeyboardNotif){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDefaultKeyboard = YES;
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    self.emojiButtonImageArray = @[@"btn_expression",@"btn_keyboard"];
    self.isRegistedKeyboardNotif = NO;
    [self addSubview:self.topView];
    [self.topView addSubview:self.topLine];
    [self.topView addSubview:self.inputTextView];
    [self.topView addSubview:self.emojiButton];
    [self.topView addSubview:self.addButton];
    [self.topView addSubview:self.bottomLine];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.topView);
        make.height.mas_equalTo(1);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.right.equalTo(self.bottomLine.mas_right).offset(-80);
        make.height.equalTo(@(40)).priorityHigh();
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomLine.mas_bottom).offset(-10);
        make.left.equalTo(self.inputTextView.mas_right).offset(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.emojiButton);
        make.left.equalTo(self.emojiButton.mas_right).offset(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)registerKeyboardNotif{
    _isRegistedKeyboardNotif = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setFitWhenKeyboardShowOrHide:(BOOL)fitWhenKeyboardShowOrHide{
    if (fitWhenKeyboardShowOrHide){
        [self registerKeyboardNotif];
    }
    if (!fitWhenKeyboardShowOrHide && _isDefaultKeyboard){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    _isDefaultKeyboard = fitWhenKeyboardShowOrHide;
}

- (void)showKeyBoardOrOtherKeyBoard
{
    if (self.emojiButton.tag == 1){
        NSLog(@"11111");
        _emojiButton.tag = 0;

        self.isDefaultKeyboard = YES;
        [self.inputTextView becomeFirstResponder];
        
    }else{
        self.isDefaultKeyboard = NO;
        [self.inputTextView resignFirstResponder];
        _emojiButton.tag = 1;

        CGRect frame = self.frame;
        frame.origin.y =[UIScreen mainScreen].bounds.size.height - self.frame.size.height - 150;
//        frame.size.height = self.emojiKeyBoardView.frame.size.height + self.topView.bounds.size.height;
//        [self duration:0.25f EndF:frame Options:UIViewAnimationOptionCurveLinear];
        [self.delegate keyBoardView:frame ChangeDuration:0.25 EmojikeyBoardType:YES];
    }
    [_emojiButton setImage:[UIImage imageNamed:_emojiButtonImageArray[_emojiButton.tag]] forState:UIControlStateNormal];
    
}

- (void)duration:(CGFloat)duration EndF:(CGRect)endF Options:(UIViewAnimationOptions)options{
    
    if (self.isDefaultKeyboard == NO) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             
                             CGRect newInputBarFrame = endF;
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.mas_equalTo(0);
                                 make.left.mas_equalTo(0);
                                 make.width.mas_equalTo(WIDTH);
                             }];
                             
                         }
                         completion:nil];
    }else{
        NSLog(@"vvvv");
    }
}



#pragma mark - notif

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect newInputBarFrame = self.frame;
    newInputBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height-kbSize.height;
    [self.delegate keyBoardView:newInputBarFrame ChangeDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] EmojikeyBoardType:NO];
    _emojiButton.tag = 0;
    [_emojiButton setImage:[UIImage imageNamed:_emojiButtonImageArray[_emojiButton.tag]] forState:UIControlStateNormal];
    

    self.isDefaultKeyboard = YES;
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                         animations:^{
                             CGRect newInputBarFrame = self.frame;
                             newInputBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.topView.frame);
                             newInputBarFrame.size.height = self.topView.frame.size.height;
                             self.frame = newInputBarFrame;
                         }
                         completion:nil];

    self.isDefaultKeyboard = NO;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        CGSize sizeThatFitsTextView = [self.inputTextView sizeThatFits:CGSizeMake((WIDTH - 100), MAXFLOAT)];
        if (sizeThatFitsTextView.height <= 40) {
    
            [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@40);
            }];
        } else if ( sizeThatFitsTextView.height >= 75 ) {
    
    
            [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@75);
            }];
    
        } else {
            [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(sizeThatFitsTextView.height);
            }];
        }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isFirstResponder]) {
        self.isDefaultKeyboard = YES;
        _emojiButton.tag = 0;
        [_emojiButton setImage:[UIImage imageNamed:_emojiButtonImageArray[_emojiButton.tag]] forState:UIControlStateNormal];
    }
}

- (UITextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.layer.borderWidth = 1.0;
        _inputTextView.layer.cornerRadius = 5.0;
        _inputTextView.font = [UIFont systemFontOfSize:16.0];
        _inputTextView.layer.borderColor = [UIColor colorWithRed:86%255/256.0 green:203%255/256.0 blue:157%255/256.0 alpha:1].CGColor;
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (UIButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.tag = 0;
        [_emojiButton setBackgroundImage:[UIImage imageNamed:_emojiButtonImageArray[_emojiButton.tag]] forState:UIControlStateNormal];
        @weakify(self);
        _emojiButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self showKeyBoardOrOtherKeyBoard];
            return [RACSignal empty];
        }];
    }
    return _emojiButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor blueColor];
        [_addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _addButton;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}


@end
