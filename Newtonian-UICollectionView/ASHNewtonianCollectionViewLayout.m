//
//  ASHNewtonianCollectionViewLayout.m
//  Newtonian-UICollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//
//

#import "ASHNewtonianCollectionViewLayout.h"

@implementation ASHNewtonianCollectionViewLayout

-(id)init {
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(100, 100);
    
    return self;
}

@end
