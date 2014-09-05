//
//  CollectionViewCell.h
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryLevels.h"
@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) StoryLevels *level;
@property (strong, nonatomic) UINavigationController *navControlelr;

@end
