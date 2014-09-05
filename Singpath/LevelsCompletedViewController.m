//
//  levelsCompletedViewController.m
//  Singpath
//
//  Created by Rishik on 14/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "levelsCompletedViewController.h"
#import "CVCell.h"

@interface LevelsCompletedViewController ()

@end

@implementation LevelsCompletedViewController
@synthesize choices=_choices;



- (void)viewDidLoad
{
    [super viewDidLoad];
  //  self.dataArray = [[NSArray alloc] initWithObjects:self.choices, nil];
  //  [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    /* end of subclass-based cells block */
    
    // Configure layout
   /* UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(200, 200)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView reloadData];*/
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.choices count]/5;// [self.choices count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
   // static NSString *CellIdentifier = @"Cell1";

    /*  Uncomment this block to use nib-based cells */
    // UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    // [titleLabel setText:cellData];
    /* end of nib-based cell block */
    
    /* Uncomment this block to use subclass-based cells */
    
    //CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    

  //  CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath ];
    CVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 //       NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    NSString *cellData = [self.choices objectAtIndex:(indexPath.section*2 + indexPath.row)];
    //[cell.titleLabel setText:cellData];
    UIImage *img=[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@.png",cellData]];
    cell.imageView.image=img;
    /* end of subclass-based cells block */
    
    // Return the cell
    return cell;
    
}
@end



