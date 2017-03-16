//
//  QYCEmojiCollectionViewFlowLayout.m
//  
//
//  Created by 晓琳 on 17/3/13.
//
//

#import "QYCEmojiCollectionViewFlowLayout.h"

@interface QYCEmojiCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray *allAttributes;
// 一行中 cell的个数
@property (nonatomic, assign) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic, assign) NSUInteger rowCount;

@end
@implementation QYCEmojiCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.allAttributes = [NSMutableArray array];
    self.itemCountPerRow = 8;
    self.rowCount = 3;
    self.minimumLineSpacing = 95.0/7;
    self.minimumInteritemSpacing = 10;
    self.itemSize = CGSizeMake(30, 30);
    self.sectionInset = UIEdgeInsetsMake(25, 20, 35, 20);
    
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++){
        NSMutableArray * tmpArray = [NSMutableArray array];
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        
        for (NSUInteger j = 0; j<count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [tmpArray addObject:attributes];
        }
        [self.allAttributes addObject:tmpArray];
    }
    NSLog(@"tmpArraycount = %ld",self.allAttributes.count);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self targetPosition:attributes];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    [self.allAttributes enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger i, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(CGRectIntersectsRect(obj.frame, rect)) {
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];
    return layoutAttributesArr;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(375*5, 150);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (void)targetPosition:(UICollectionViewLayoutAttributes *)attribute
{
    if (!attribute) {
        return;
    }
    NSUInteger page = attribute.indexPath.section;
    CGFloat theX = (attribute.indexPath.row % self.itemCountPerRow + page * self.itemCountPerRow) * 30 + 30 + 95.0/7*(attribute.indexPath.row%8);
    CGFloat theY = (attribute.indexPath.row / self.itemCountPerRow - page * self.rowCount) * 40 + 35;
    attribute.frame = CGRectMake(theX, theY, 30, 30);
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    return targetP;
}


@end
