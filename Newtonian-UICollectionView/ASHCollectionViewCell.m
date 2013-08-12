//
//  ASHCollectionViewCell.m
//  Newtonian-UICollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//
//

#import "ASHCollectionViewCell.h"

@interface ASHCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ASHCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

-(void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end
