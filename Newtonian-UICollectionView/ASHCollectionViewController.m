//
//  ASHCollectionViewController.m
//  Newtonian-UICollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//
//

#import "ASHCollectionViewController.h"
#import "ASHCollectionViewCell.h"

@interface ASHCollectionViewController ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation ASHCollectionViewController

static NSString *CellIdentifier = @"Cell";

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(userDidPressTrashButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(userDidPressAddButton:)];
    
    self.count = 5;
    
    [self.collectionView registerClass:[ASHCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

#pragma mark - User Interaction Methods

-(void)userDidPressAddButton:(id)sender {
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count inSection:0]]];
        self.count++;
    } completion:nil];
}

-(void)userDidPressTrashButton:(id)sender {
    [self.collectionView performBatchUpdates:^{
        // Prevent count from going below zero.
        if (self.count > 0) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count-1 inSection:0]]];
            self.count--;
        }
    } completion:nil];
}

#pragma mark - UICollectionViewDataSource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg", indexPath.row % 5];
    [cell setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

@end
