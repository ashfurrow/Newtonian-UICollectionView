//
//  ASHNewtonianCollectionViewLayout.m
//  Newtonian-UICollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//
//

#import "ASHNewtonianCollectionViewLayout.h"

static CGFloat kItemSize = 100.0f;
#define attachmentPoint CGPointMake(CGRectGetMidX(self.collectionView.bounds), 64)

@interface ASHNewtonianCollectionViewLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, weak) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, weak) UICollisionBehavior *collisionBehaviour;

@property (nonatomic, strong) NSMutableSet *insertedRowSet;
@property (nonatomic, strong) NSMutableSet *deletedRowSet;

@end

@implementation ASHNewtonianCollectionViewLayout

#pragma mark - Overridden Methods

-(id)init {
    if (!(self = [super init])) return nil;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    
    self.insertedRowSet = [NSMutableSet set];
    self.deletedRowSet = [NSMutableSet set];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[]];
    gravityBehaviour.gravityDirection = CGVectorMake(0, 1);
    self.gravityBehaviour = gravityBehaviour;
    [self.dynamicAnimator addBehavior:gravityBehaviour];
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[]];
    [self.dynamicAnimator addBehavior:collisionBehaviour];
    self.collisionBehaviour = collisionBehaviour;
    
    return self;
}


-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

-(void)prepareLayout {
    [super prepareLayout];
    
//    CGRect visibleRect = self.collectionView.bounds;
//    
//    NSArray *items = [super layoutAttributesForElementsInRect:visibleRect];
//    
//    if (items.count > 0 && self.dynamicAnimator.behaviors.count == 2) {
//        
//        [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
//            UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:attachmentPoint];
//            
//            springBehaviour.length = 10.0f;
//            springBehaviour.damping = 0.8f;
//            springBehaviour.frequency = 1.0f;
//            
//            [self.dynamicAnimator addBehavior:springBehaviour];
//            [self.gravityBehaviour addItem:obj];
//            [self.collisionBehaviour addItem:obj];
//        }];
//    }
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert)
        {
            [self.insertedRowSet addObject:@(updateItem.indexPathAfterUpdate.item)];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
            
            attributes.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame) + kItemSize, 300, kItemSize, kItemSize);

            UIAttachmentBehavior *attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:attributes attachedToAnchor:attachmentPoint];
            attachmentBehaviour.length = 300.0f;
            attachmentBehaviour.damping = 0.4f;
            attachmentBehaviour.frequency = 1.0f;
            [self.dynamicAnimator addBehavior:attachmentBehaviour];
            
            [self.gravityBehaviour addItem:attributes];
            [self.collisionBehaviour addItem:attributes];
        }
        else if (updateItem.updateAction == UICollectionUpdateActionDelete)
        {
            [self.deletedRowSet addObject:@(updateItem.indexPathBeforeUpdate.item)];
            
//            __block UICollectionViewLayoutAttributes *attributes;
//            __block UICollisionBehavior *collisionBehaviour;
//            
//            [self.collisionBehaviour.items enumerateObjectsUsingBlock:^(UICollisionBehavior *obj, NSUInteger idx, BOOL *stop) {
//                if ([[obj.items.firstObject indexPath] isEqual:updateItem.indexPathBeforeUpdate]) {
//                    collisionBehaviour = obj;
//                    attributes = obj.items.firstObject;
//                    *stop = YES;
//                }
//            }];
//
//            [self.gravityBehaviour removeItem:attributes];
//            [self.collisionBehaviour removeItem:attributes];
//            [self.dynamicAnimator removeBehavior:collisionBehaviour];
        }
    }];
}

-(void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    
    [self.insertedRowSet removeAllObjects];
    [self.deletedRowSet removeAllObjects];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
//    if ([self.insertedRowSet containsObject:@(itemIndexPath.item)])
//    {
//        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
//        
//        attributes.center = self.collectionView.center;
//        attributes.bounds = CGRectMake(0, 0, kItemSize, kItemSize);
//
//        return attributes;
//    }
    
    UICollectionViewLayoutAttributes *attributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:itemIndexPath];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deletedRowSet containsObject:@(itemIndexPath.item)])
    {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0.0;
        
        return attributes;
    }
    
    return attributes;
}

#pragma mark - Public methods
-(void)detachItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    __block UIAttachmentBehavior *attachmentBehaviour;
    __block UICollectionViewLayoutAttributes *attributes;
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIAttachmentBehavior class]]) {
            if ([[[obj items].firstObject indexPath] isEqual:indexPath]) {
                attachmentBehaviour = obj;
                attributes = [[obj items] firstObject];
                *stop = YES;
            }
        }
    }];
    
    [self.dynamicAnimator removeBehavior:attachmentBehaviour];
    
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collisionBehaviour removeItem:attributes];
        [self.gravityBehaviour removeItem:attributes];
        
        [self.collectionView performBatchUpdates:^{
            completion();
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    });
}

@end
