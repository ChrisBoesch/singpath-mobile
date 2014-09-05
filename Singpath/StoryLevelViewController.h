//
//  StoryLevelViewController.h
//  Singpath
//
//  Created by Rishik on 19/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryLevelGridViewController.h"
@interface StoryLevelViewController : UIViewController
{
    NSMutableArray *_levels;
    NSString *_pathid;
    NSString *_storyName;
    NSString *_storyId;


    
        
}
@property (nonatomic, retain) NSArray *levels;
@property (strong,nonatomic) NSString *pathid;
@property (strong,nonatomic) NSString *storyName;
@property (strong,nonatomic) NSString *storyId;
@property(strong,nonatomic) IBOutlet StoryLevelGridViewController *storyLevelGridViewController;
@property(strong,nonatomic) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;



@property (nonatomic, strong) IBOutlet UIImageView *imgView;



@end