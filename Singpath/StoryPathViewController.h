//
//  StoryPathViewController.h
//  Singpath
//
//  Created by Rishik on 19/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface StoryPathViewController : UIViewController
{
    NSString *_pathid;
    NSString *_storyid;
    NSString *_storyName;
    NSString *_pathName;
    NSArray *_tableData;
    NSMutableArray *_pathIds;

    NSMutableArray *_levelCompleted;
    NSArray *_paths;
    
}
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UIButton *backToHome;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;

@property (nonatomic, retain) NSArray *paths;
@property (nonatomic, retain) NSMutableArray *pathIds;
@property (nonatomic, strong) IBOutlet UILabel *heading;

@property (nonatomic, retain) NSMutableArray *levelCompleted;
@property (strong,nonatomic) NSString *pathid;
@property (strong,nonatomic) NSString *storyid;
@property (strong,nonatomic) NSString *storyName;

@property (strong,nonatomic) NSString *pathName;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;



@end