//
//  EmojiFlowLayout.m
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/3/15.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import "EmojiFlowLayout.h"

@interface EmojiFlowLayout ()

// 一行中 cell的个数
@property (nonatomic, assign) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic, assign) NSUInteger rowCount;

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation EmojiFlowLayout
{
    NSInteger _cellCount;
    CGSize _boundsSize;
}

- (void)prepareLayout
{
    // Get the number of cells and the bounds size
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _boundsSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 95.0/7;
    self.itemCountPerRow = 8;
    self.rowCount = 3;

}

- (CGSize)collectionViewContentSize
{
    // We should return the content size. Lets do some math:
    
    NSInteger verticalItemsCount = self.rowCount;
    NSInteger horizontalItemsCount = self.itemCountPerRow;
    
    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
    NSInteger numberOfItems = _cellCount;
    NSInteger numberOfPages = numberOfItems/itemsPerPage;

    
    CGSize size = _boundsSize;
    size.width = numberOfPages * _boundsSize.width;
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // This method requires to return the attributes of those cells that intsersect with the given rect.
    // In this implementation we just return all the attributes.
    // In a better implementation we could compute only those attributes that intersect with the given rect.
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:_cellCount];
    
    for (NSUInteger i=0; i<_cellCount; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self _layoutForAttributesForCellAtIndexPath:indexPath];
        
        [allAttributes addObject:attr];
    }
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _layoutForAttributesForCellAtIndexPath:indexPath];
}
- (UICollectionViewLayoutAttributes*)_layoutForAttributesForCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    
    CGRect bounds = self.collectionView.bounds;
    CGSize itemSize = CGSizeMake(30, 30);
    
    // Get some info:
    NSInteger verticalItemsCount = 3;
    NSInteger horizontalItemsCount = 8;
    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
    
    // Compute the column & row position, as well as the page of the cell.
    NSInteger columnPosition = row%horizontalItemsCount;
    NSInteger rowPosition = (row/horizontalItemsCount)%verticalItemsCount;
    NSInteger itemPage = floorf(row/itemsPerPage);
    
    // Creating an empty attribute
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    
    // And finally, we assign the positions of the cells
    frame.origin.x = itemPage * bounds.size.width + columnPosition * itemSize.width + 20 + (bounds.size.width - 30*8 - 40)/7 *columnPosition;
    frame.origin.y = rowPosition * (itemSize.height + 19.5) + 20;

    frame.size = itemSize;
    
    attr.frame = frame;
    
    return attr;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // We should do some math here, but we are lazy.
    return YES;
}

- (void)setItemSize:(CGSize)itemSize
{
    itemSize = itemSize;
    [self invalidateLayout];
}

@end
