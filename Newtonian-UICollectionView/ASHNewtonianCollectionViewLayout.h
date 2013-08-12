//
//  ASHNewtonianCollectionViewLayout.h
//  Newtonian-UICollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//
//

#import <UIKit/UIKit.h>

@interface ASHNewtonianCollectionViewLayout : UICollectionViewLayout

-(void)detachItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion;

@end
