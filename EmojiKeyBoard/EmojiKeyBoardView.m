//
//  EmojiKeyBoardView.m
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/2/28.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "EmojiKeyBoardView.h"
#import "EmojiCollectionViewCell.h"
#import "Masonry.h"
#import "NSString+Emoji.h"
#import "QYCEmojiCollectionViewFlowLayout.h"
#import "EmojiFlowLayout.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface EmojiKeyBoardView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *emojiDataSource;
@property (nonatomic, strong) UIImageView *emojiPreview;

@end

@implementation EmojiKeyBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupConstraints];
        [self bindEmojiData];
    }
    return self;
}

- (void)setupConstraints
{
    
//    self.contentSize = CGSizeMake(WIDTH * 5, 190);
//    self.scrollEnabled = YES;
    
    self.backgroundColor = [UIColor colorWithRed:246%255/256.0 green:246%255/256.0 blue:246%255/256.0 alpha:1];
    
    [self addSubview:self.emojiCollectionView];
    [self addSubview:self.emojiPageControl];
    [self addSubview:self.sendButton];
    
    [self.emojiCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(150);
    }];
    
    [self.emojiPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.emojiCollectionView.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.bottom.equalTo(self).offset(-40);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-40);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [super updateConstraints];
}

- (void) setupSubViews
{
    
}



- (void) previewEmoji:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    CGPoint p = [gestureRecognizer locationInView:self.emojiCollectionView];
    NSIndexPath *indexPath = [self.emojiCollectionView indexPathForItemAtPoint:p];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.emojiPreview.hidden = YES;
        self.emojiPreview = nil;
        return;
    }
    if (self.emojiPreview) {
        self.emojiPreview.hidden = YES;
        self.emojiPreview = nil;
    }
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
        EmojiCollectionViewCell *cell =
        [self.emojiCollectionView cellForItemAtIndexPath:indexPath];
        [self showEmojiPreview:indexPath];
            // do stuff with the cell
        }

}

- (void) showEmojiPreview:(NSIndexPath *)indexPath
{
    if (self.emojiPreview) {
        return;
    }
    EmojiCollectionViewCell *cell =
    [self.emojiCollectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = cell.frame;

    CGRect previewRect = CGRectMake(rect.origin.x -12.5 - WIDTH * self.emojiPageControl.currentPage, rect.origin.y - 70, 55, 70);
    UIImageView *preview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoji_background"]];
    preview.frame = previewRect;
    [self addSubview:preview];
    
    UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    emojiLabel.textAlignment = 1;
    [preview addSubview:emojiLabel];
    
    emojiLabel.text = [self.emojiDataSource objectAtIndex:indexPath.row/24];
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, emojiLabel.frame.origin.y + emojiLabel.frame.size.height + 1.5, 45, 15)];
    noteLabel.textAlignment = 1;
    noteLabel.textColor = [UIColor colorWithRed:68%255/256.0 green:68%255/256.0 blue:68%255/256.0 alpha:1];
    noteLabel.font = [UIFont systemFontOfSize:11];
    [preview addSubview:noteLabel];
    
    noteLabel.text = @"哈哈";
    
    self.emojiPreview = preview;
}




- (void)bindEmojiData
{
    NSDictionary *dic = [NSString getAllEmoji];
    self.emojiDataSource = [dic allValues] ;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = ceilf(scrollView.contentOffset.x / WIDTH);
    self.emojiPageControl.currentPage = currentPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiCell" forIndexPath:indexPath];
    NSString *emoji = [NSString replaceUnicode:[self.emojiDataSource objectAtIndex:indexPath.row/24]];
    cell.emojiLabel.text = emoji;

    return cell;
}

 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 23) {
        [self.emojiDelegate emojiViewDelete];
    }else{
        NSString *emoji = [self.emojiDataSource objectAtIndex:indexPath.row/24];
        [self.emojiDelegate showEmoji:emoji];
    }
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(25, 20, 35, 20);
//}

//
//- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
////    return 0;
//}
//
//- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return ([UIScreen mainScreen].bounds.size.width - 30*8 - 40)/7;
////    return 0;
//}

-( NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3 * 8 *5;
}
- (UICollectionView *)emojiCollectionView
{
    if (!_emojiCollectionView) {
        EmojiFlowLayout *flowlayout = [[EmojiFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowlayout.itemSize = CGSizeMake(30, 30);
        _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150) collectionViewLayout:flowlayout];
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.scrollEnabled = YES;
        _emojiCollectionView.contentSize = CGSizeMake(WIDTH *5, 150);
        _emojiCollectionView.backgroundColor = [UIColor colorWithRed:246%255/256.0 green:246%255/256.0 blue:246%255/256.0 alpha:1];
        _emojiCollectionView.pagingEnabled = YES;
        _emojiCollectionView.showsHorizontalScrollIndicator = NO;
        _emojiCollectionView.showsVerticalScrollIndicator = NO;
        _emojiCollectionView.alwaysBounceHorizontal = YES;
        [_emojiCollectionView registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"emojiCell"];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(previewEmoji:)];
        longTap.minimumPressDuration = 0.5;
        [_emojiCollectionView addGestureRecognizer:longTap];
        longTap.delegate = self;

    }
    return _emojiCollectionView;
}
- (UIPageControl *)emojiPageControl
{
    if (!_emojiPageControl) {
        _emojiPageControl = [[UIPageControl alloc] init];
        _emojiPageControl.currentPage = 0;
        _emojiPageControl.numberOfPages = 5;
        _emojiPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _emojiPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _emojiPageControl.alpha = 0.6;
    }
    return _emojiPageControl;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = [UIColor colorWithRed:36%255/256.0 green:191%255/256.0 blue:124%255/256.0 alpha:1];
        [_sendButton setTitle:@"发送" forState:0];
    }
    return _sendButton;
}

@end
