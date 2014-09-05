//
//  ViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryLevelGridViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray * levelIdArray;
@property (strong, nonatomic) NSMutableArray * levelNameArray;
@property (strong, nonatomic) NSMutableArray * videoArray;
@property (strong, nonatomic) NSMutableArray * completedArray;
@property (strong, nonatomic) NSMutableArray * levelsArray;
@property (strong, nonatomic) UINavigationController * navController;


@end
