//
//  LevelViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 9/8/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelViewController : UIViewController
{
    NSString *_levelid;
    NSString *_levelName;
    NSArray *_tableData;
    NSMutableArray *_problemSetIds;
    NSMutableArray *_levelCompleted;
    NSArray *_levels;
    BOOL _settingsCheck;
    BOOL _profileCheck;
}
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;

@property (nonatomic, retain) NSArray *levels;
@property (nonatomic, retain) NSMutableArray *problemSetIds;
@property (nonatomic, retain) NSMutableArray *levelCompleted;
@property (strong,nonatomic) NSString *levelid;
@property (strong,nonatomic) NSString *levelName;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property(strong,nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic) BOOL settingsCheck;
@property (nonatomic) BOOL profileCheck;

@property(strong,nonatomic) IBOutlet UIButton *profileButton;
@property (nonatomic, strong) IBOutlet UIButton *backToHome;



@end
